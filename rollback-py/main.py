import logging
from time import sleep
import boto3 
from utils import * 
import argparse

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler())


class EcsManager():

    def __init__(self,region='us-east-1'):
        self.ecs_client = boto3.client('ecs',region_name=region)
        self.rgtag_client = boto3.client('resourcegroupstaggingapi',region_name=region)

    def tag_task_definition(self,task_definition_arn,tags):
        self.ecs_client.tag_resource(
                resourceArn=task_definition_arn,
                tags=tags
            )
        
    def untag_task_definition(self,task_definition_arn,tag_keys):
        self.ecs_client.untag_resource(
            resourceArn=task_definition_arn,
            tagKeys=tag_keys 
        )

    def get_last_successfull_task_definition_arn(self,tagfilters):
        response = self.rgtag_client.get_resources(
                    TagFilters=tagfilters,
                    ResourcesPerPage=1,
                    ResourceTypeFilters=[
                    'ecs:task-definition',
                    ]
        )
        if len(response['ResourceTagMappingList']):
            return response['ResourceTagMappingList'][0]['ResourceARN']
        return None

    
    def is_healthy(self,cluster_name,service_name,task_definition_arn):
        current_deployment = None 
        svc = self.get_service(cluster_name,service_name)
        svc_deployments = svc['deployments']
        for svc_deployment in svc_deployments:
            if svc_deployment['taskDefinition'] == task_definition_arn:
                current_deployment = svc_deployment
                break 
        if current_deployment['runningCount'] >=  current_deployment['desiredCount'] and current_deployment['status'] == 'PRIMARY':
            return True  
        return False 

    def get_container_image(self,task_definition_arn):
            response = self.ecs_client.describe_task_definition(
                taskDefinition=task_definition_arn,
                include=[
                    'TAGS',
                ]
            )
            for container_def in response['taskDefinition']['containerDefinitions']:
                if container_def['essential']:
                    return container_def['image']
            return None 

    def get_service(self,cluster_name,service_name):
        response = self.ecs_client.describe_services(
            cluster=cluster_name,
            services=[
                service_name,
            ],
            include=[
                'TAGS',
            ]
            )     
        if len(response['services']):
            return response['services'][0]
        else:
            raise Exception(f'Service {service_name} not found')


    def reconcile(self,cluster_name,service_name,wait_count):
        try:
            svc = self.get_service(cluster_name,service_name)
            current_task_definition_arn = svc['taskDefinition']
            current_container_image = self.get_container_image(current_task_definition_arn)
            current_container_image_version = current_container_image.split(':')[-1]
            last_successfull_task_definition_arn = self.get_last_successfull_task_definition_arn(
                tagfilters=[
                        {'Key': 'isHealthy','Values':['True']},
                        {'Key': 'isLatest','Values':['True']},
                        {'Key': 'serviceName','Values': [service_name]},
                        {'Key': 'clusterName','Values':[cluster_name]},
                    ])
   

            if last_successfull_task_definition_arn == current_task_definition_arn:
                logger.info(green(f'Currently running task definition {last_successfull_task_definition_arn} is healthy'))
                return 

            counter = 1
            while(counter < wait_count):
                if self.is_healthy(cluster_name,service_name,current_task_definition_arn):
                    logger.info(blue(f'Deployment with the current task definition arn {current_task_definition_arn} looks healthy.\nWaiting for last 20 seconds to verify the health.'))
                    sleep(10)
                    if self.is_healthy(cluster_name,service_name,current_task_definition_arn):
                        logger.info(green(f'Deployment with the current task definition arn {current_task_definition_arn} is healthy'))
                        logger.info(blue(f'Tagging the current task definition as healthy {current_task_definition_arn}'))
                        self.tag_task_definition(current_task_definition_arn,tags=[
                            {'key': 'isHealthy','value':'True'},
                            {'key': 'isLatest','value':'True'},
                            {'key': 'imageTag','value':current_container_image_version},
                            {'key': 'serviceName','value': service_name},
                            {'key':'clusterName','value':cluster_name}
                        ])
                        if last_successfull_task_definition_arn:
                            logger.info(blue(f'Untagging the last healthy version {last_successfull_task_definition_arn}')) 
                            self.untag_task_definition(last_successfull_task_definition_arn,tag_keys=['isLatest'])   
                        return     
                    else:
                        break 
                logger.info(blue(f'Waiting for the tasks to be up with the current task definition {current_task_definition_arn}'))
                sleep(counter * 1)
                counter+=1
            
            if last_successfull_task_definition_arn is None:
                logger.warning(blue(f'No successfully deployed task definition found for the service {service_name}'))
                logger.error(red('Exiting... Cannot rollback as there is no healhy task definition found.'))
                return   

            logger.info(red(f'Tasks looks unhealthy with the current task definition {current_task_definition_arn}. Rollback to last healthy version {last_successfull_task_definition_arn}'))
            self.ecs_client.update_service(cluster=cluster_name,service=service_name,taskDefinition=last_successfull_task_definition_arn)
            logger.info(green(f'Successfully Rollbacked to last healthy version {last_successfull_task_definition_arn}'))
        except Exception as e:
            logger.error(red(f'{e}'))

    def update_service_with_given_task_definition(self,cluster_name,service_name,container_image_version):

        last_successfull_task_definition_arn = self.get_last_successfull_task_definition_arn(
            tagfilters=[
                    {'Key': 'isHealthy','Values':['True']},
                    {'Key': 'isLatest','Values':['True']},
                    {'Key': 'imageTag','Values':[container_image_version]},
                    {'Key': 'serviceName','Values': [service_name]},
                    {'Key': 'clusterName','Values':[cluster_name]},
                ])
         
        if last_successfull_task_definition_arn is None:
            last_healthy_task_definition_arn = self.get_last_successfull_task_definition_arn(
                tagfilters=[
                        {'Key': 'isHealthy','Values':['True']},
                        {'Key': 'imageTag','Values':[container_image_version]},
                        {'Key': 'serviceName','Values': [service_name]},
                        {'Key': 'clusterName','Values':[cluster_name]},
                    ])
            if last_healthy_task_definition_arn is None:
                logger.error(red(f'Cannot find the healthy task definition with this image version {container_image_version}'))
            else:
                logger.info(blue(f'Found healthy task defintion {last_healthy_task_definition_arn} with the given image version {container_image_version}.\nUpdating the service'))
                self.ecs_client.update_service(cluster=cluster_name,service=service_name,taskDefinition=last_healthy_task_definition_arn)
                logger.info(green(f'Successfully Updated the service with task defintion {last_healthy_task_definition_arn}'))
        else:
            logger.info(blue(f'Already running the tasks {last_successfull_task_definition_arn} with the same container image version'))
            
if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Simple ECS rollback manager for Fargate Rolling Update Deployment Type')
    parser.add_argument('--region', help='Name of the Region in which ECS Cluster is present', required=True)
    parser.add_argument('--cluster', help='Name of the ECS Fargate Cluster', required=True)
    parser.add_argument('--service', help='Name of the ECS Fargate Service', required=True)
    parser.add_argument('--wait-time', help='Amount of time to wait for the the tasks to be healthy, the health checks by load balancers is not included in this time', required=False,default=10)
    parser.add_argument('--app-image-tag', help='Image tag for which the healthy task definition will be searched and if found service will be updated, otherwise it will error out', required=False,default='')
    
    args = vars(parser.parse_args())

    cluster_name,service_name = args['cluster'],args['service']
    ecs = EcsManager(region=args['region'])
    if len(args['app_image_tag']) > 0:
            logger.info(blue(f'Trying to find the task definition with the given image tag {args["app_image_tag"]}'))
            ecs.update_service_with_given_task_definition(cluster_name,service_name,args['app_image_tag'])

    logger.info(blue(f'Starting to perform health check for atmost {int(args["wait_time"])+20} seconds'))
    ecs.reconcile(cluster_name,service_name,int(args['wait_time']))