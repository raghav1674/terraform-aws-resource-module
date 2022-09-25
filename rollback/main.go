package main

import (
	"fmt"
	"strings"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/credentials/stscreds"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ecs"
	"github.com/aws/aws-sdk-go/service/resourcegroupstaggingapi"
	"k8s.io/klog"
)

type SimpleTag struct {
	Key   string
	Value string
}

type AccessConfig struct {
	Region  string
	Profile string
	RoleARN string
}

type EcsDeployClient struct {
	AccessConfig
	ecs                      *ecs.ECS
	resourcegroupstaggingapi *resourcegroupstaggingapi.ResourceGroupsTaggingAPI
}

func (ecsDeployClient *EcsDeployClient) NewClient() {

	var creds *credentials.Credentials

	config := aws.Config{
		Region:      &ecsDeployClient.Region,
		Credentials: creds,
	}

	opts := session.Options{
		Config: config,
	}

	if ecsDeployClient.Profile != "" {
		opts.Profile = ecsDeployClient.Profile
	}

	sess, err := session.NewSessionWithOptions(opts)

	if err != nil {
		klog.Errorf("could not create aws session: %s", err.Error())
		return
	}

	if ecsDeployClient.RoleARN != "" {
		creds = stscreds.NewCredentials(sess, ecsDeployClient.RoleARN, func(provider *stscreds.AssumeRoleProvider) {
			provider.RoleSessionName = fmt.Sprintf("ecs-deploy-session-%s", time.Now().Month())
			provider.Duration = 75 * time.Minute
		})
	}
	_, err = sess.Config.Credentials.Get()
	if err != nil {
		klog.Errorf("could not create aws session: %s", err.Error())
		return
	}
	ecsDeployClient.ecs = ecs.New(sess, &aws.Config{Credentials: creds})
	ecsDeployClient.resourcegroupstaggingapi = resourcegroupstaggingapi.New(sess, &aws.Config{Credentials: creds})
}

func (ecsDeployClient *EcsDeployClient) DescribeCluster(clusterName string) (*ecs.Cluster, error) {

	clusterOutput := &ecs.Cluster{}

	res, err := ecsDeployClient.ecs.DescribeClusters(&ecs.DescribeClustersInput{
		Clusters: aws.StringSlice([]string{clusterName}),
	})
	if err != nil {
		return clusterOutput, err
	}
	for _, cluster := range res.Clusters {
		if strings.EqualFold(clusterName, *cluster.ClusterName) {
			return cluster, nil
		}
	}
	return clusterOutput, nil
}

func (ecsDeployClient *EcsDeployClient) DescribeService(clusterName string, serviceName string) (*ecs.Service, error) {

	serviceOutput := &ecs.Service{}
	res, err := ecsDeployClient.ecs.DescribeServices(&ecs.DescribeServicesInput{
		Cluster:  aws.String(clusterName),
		Services: aws.StringSlice([]string{serviceName}),
	})
	if err != nil {
		return serviceOutput, err
	}
	for _, service := range res.Services {
		if strings.EqualFold(serviceName, *service.ServiceName) {
			return service, nil
		}
	}
	return serviceOutput, nil
}

func (ecsDeployClient *EcsDeployClient) ListTaskArns(clusterName string, serviceName string) ([]string, error) {

	res, err := ecsDeployClient.ecs.ListTasks(&ecs.ListTasksInput{
		Cluster:     aws.String(clusterName),
		ServiceName: aws.String(serviceName),
	})
	if err != nil {
		return []string{}, err
	}
	taskArns := []string{}
	for _, taskarn := range res.TaskArns {
		taskArns = append(taskArns, *taskarn)
	}
	return taskArns, nil

}

func (ecsDeployClient *EcsDeployClient) DescribeTask(clusterName string, taskArn string) (*ecs.Task, error) {

	taskOutput := &ecs.Task{}
	res, err := ecsDeployClient.ecs.DescribeTasks(&ecs.DescribeTasksInput{
		Cluster: aws.String(clusterName),
		Tasks:   aws.StringSlice([]string{taskArn}),
	})
	if err != nil {
		return taskOutput, err
	}
	for _, task := range res.Tasks {
		if strings.EqualFold(taskArn, *task.TaskArn) {
			return task, nil
		}
	}
	return taskOutput, nil

}
func (ecsDeployClient *EcsDeployClient) DescribeTaskDefinition(taskDefintionArn string) (*ecs.TaskDefinition, error) {
	taskDefinitionOutput := &ecs.TaskDefinition{}
	res, err := ecsDeployClient.ecs.DescribeTaskDefinition(&ecs.DescribeTaskDefinitionInput{
		TaskDefinition: &taskDefintionArn,
	})
	if err != nil {
		return taskDefinitionOutput, err
	}
	return res.TaskDefinition, nil
}

func (ecsDeployClient *EcsDeployClient) ListTaskDefintions(familyPrefix string) ([]string, error) {
	taskDefinitionOutput := []string{}
	res, err := ecsDeployClient.ecs.ListTaskDefinitions(&ecs.ListTaskDefinitionsInput{
		FamilyPrefix: aws.String(familyPrefix),
		MaxResults:   aws.Int64(2),
	})
	if err != nil {
		return taskDefinitionOutput, err
	}
	taskDefintionArns := []string{}
	for _, td := range res.TaskDefinitionArns {
		taskDefintionArns = append(taskDefintionArns, *td)
	}
	return taskDefintionArns, nil

}

func (ecsDeployClient *EcsDeployClient) UpdateService(clusterName string, serviceName string, taskDefintionArn string) (*ecs.UpdateServiceOutput, error) {

	res, err := ecsDeployClient.ecs.UpdateService(&ecs.UpdateServiceInput{
		Cluster:        aws.String(clusterName),
		Service:        aws.String(serviceName),
		TaskDefinition: aws.String(taskDefintionArn),
	})
	if err != nil {
		return &ecs.UpdateServiceOutput{}, err
	}
	return res, nil
}

func (ecsDeployClient *EcsDeployClient) CheckServiceDesiredCountStatus(clusterName string, serviceName string, currentTaskDefintionArn string) (int64, int64, error) {

	svc, err := ecsDeployClient.DescribeService(clusterName, serviceName)
	if err != nil {
		return -1, -1, err
	}
	desiredCount := svc.DesiredCount

	taskarns, err := ecsDeployClient.ListTaskArns(clusterName, serviceName)
	if err != nil {
		return -1, -1, err
	}
	actualRunningCount := 0
	for _, taskarn := range taskarns {
		task, err := ecsDeployClient.DescribeTask(clusterName, taskarn)
		if err != nil {
			return -1, -1, err
		}
		if *task.TaskDefinitionArn == currentTaskDefintionArn && *task.LastStatus == "RUNNING" {
			actualRunningCount++
		}
	}
	return int64(actualRunningCount), *desiredCount, nil
}

func (ecsDeployClient *EcsDeployClient) ListTaskDefintionsByTag(tags []SimpleTag) ([]*resourcegroupstaggingapi.ResourceTagMapping, error) {

	tagFilters := []*resourcegroupstaggingapi.TagFilter{}
	for _, tag := range tags {
		tagFilters = append(tagFilters, &resourcegroupstaggingapi.TagFilter{
			Key:    aws.String(tag.Key),
			Values: aws.StringSlice([]string{tag.Value}),
		})
	}

	res, err := ecsDeployClient.resourcegroupstaggingapi.GetResources(&resourcegroupstaggingapi.GetResourcesInput{
		ResourceTypeFilters: aws.StringSlice([]string{"ecs:task-definition"}),
		TagFilters:          tagFilters,
	})

	if err != nil {
		return []*resourcegroupstaggingapi.ResourceTagMapping{}, err
	}
	return res.ResourceTagMappingList, nil
}

func (ecsDeployClient *EcsDeployClient) TagTaskDefintion(taskdefintionArn string, tag SimpleTag) error {

	_, err := ecsDeployClient.ecs.TagResource(&ecs.TagResourceInput{
		ResourceArn: &taskdefintionArn,
		Tags: []*ecs.Tag{
			{
				Key:   aws.String(tag.Key),
				Value: aws.String(tag.Value),
			},
		},
	})
	if err != nil {
		return err
	}
	return nil
}

func (ecsDeployClient *EcsDeployClient) Reconcile(clusterName string, serviceName string, maxWaitChecks int) {

	// get the service current details
	service, err := ecsDeployClient.DescribeService(clusterName, serviceName)
	if err != nil {
		klog.Error(err.Error())
		return
	}

	// from the current service details get the current task defintion details
	taskdef, err := ecsDeployClient.DescribeTaskDefinition(*service.TaskDefinition)
	if err != nil {
		klog.Error(err.Error())
		return
	}
	currentTaskDefintionArn := *taskdef.TaskDefinitionArn
	taskDefinitionfamilyPrefix := *taskdef.Family

	tagFilters := []SimpleTag{
		{Key: "isLatest", Value: "true"},
		{Key: "taskDefinitionPrefix", Value: taskDefinitionfamilyPrefix},
	}
	// get the last successful task def
	lastSuccessfullTaskDef, _ := ecsDeployClient.ListTaskDefintionsByTag(tagFilters)
	// try for maxWaitChecks * 2 Seconds

	counter := 1
	for counter <= maxWaitChecks {
		// get the running & desired Count
		runningCount, desiredCount, err := ecsDeployClient.CheckServiceDesiredCountStatus(clusterName, serviceName, currentTaskDefintionArn)
		if err != nil {
			klog.Error(err.Error())
			return
		}
		if runningCount > desiredCount {
			klog.Infof("Waiting for anothor 10 seconds as running count > desired count (%d > %d) ", runningCount, desiredCount)
			time.Sleep(10 * time.Second)
		}
		// if the running count == desired count, mark the current deployment as successfull
		if runningCount == desiredCount {

			klog.Infof("Already Current/Desired %d/%d is running", runningCount, desiredCount)
			klog.Infof("Waiting for anothor 10 seconds to monitor the state of last provisioned tasks")
			time.Sleep(10 * time.Second)
			lastRunningCount, lastDesiredCount, err := ecsDeployClient.CheckServiceDesiredCountStatus(clusterName, serviceName, currentTaskDefintionArn)
			if err != nil {
				klog.Error(err.Error())
				return
			}
			if lastDesiredCount != lastRunningCount{
				counter = maxWaitChecks + 1
				klog.Infof("Latest task defintion %s tasks looks unhealthy, rollback start ...",currentTaskDefintionArn)
				continue
			}
			klog.Infof("Latest task defintion %s tasks looks healthy",currentTaskDefintionArn)
			if len(lastSuccessfullTaskDef) > 0 {
				if *lastSuccessfullTaskDef[0].ResourceARN == currentTaskDefintionArn{
					klog.Infof("Already Current/Desired %d/%d is running with correct latest successfull taskdefintion %s", runningCount, desiredCount,currentTaskDefintionArn)
					return 
				}
				//mark the last successful task def as not the latest
				klog.Infof("Removing the latest tag from %s",*lastSuccessfullTaskDef[0].ResourceARN)
				ecsDeployClient.TagTaskDefintion(*lastSuccessfullTaskDef[0].ResourceARN, SimpleTag{Key: "isLatest", Value: "false"})
			}
			klog.Infof("Tagging the latest tag to %s",currentTaskDefintionArn)
			// mark the current task def as latest
			ecsDeployClient.TagTaskDefintion(currentTaskDefintionArn, SimpleTag{Key: "isLatest", Value: "true"})
			ecsDeployClient.TagTaskDefintion(currentTaskDefintionArn, SimpleTag{Key: "taskDefinitionPrefix", Value: taskDefinitionfamilyPrefix})

			return
		}
		time.Sleep(2 * time.Second)
		klog.Infof("Current/Desired: %d/%d is running", runningCount, desiredCount)
		counter++
	}
	// after the waitCheck is finished, update the current service with the last successfull task defintion
	if len(lastSuccessfullTaskDef) > 0 {

		lastSuccessfullTaskDefintion := *lastSuccessfullTaskDef[0].ResourceARN
		_, err := ecsDeployClient.UpdateService(clusterName, serviceName, lastSuccessfullTaskDefintion)
		if err != nil {
			klog.Errorf("Error while updating the service with taskdefintion: %v", lastSuccessfullTaskDefintion)
			return
		}
		klog.Infof("Updated the Service with the Older Task Defintion: %v", lastSuccessfullTaskDefintion)
	} else {
		klog.Infof("Cannot Update the Service as there is no Task Defintion active other than the current one: %v", currentTaskDefintionArn)
		return
	}
}

