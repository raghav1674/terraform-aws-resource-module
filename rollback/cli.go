package main

import (
	"log"
	"os"

	"github.com/urfave/cli"
)

func main() {
	app := cli.NewApp()
	app.Name = "AWS ECS Simple Rollback"
	app.Usage = "Let's you rollback simple ecs deployment"
	ecsDeployClient := EcsDeployClient{}

	appFlags := []cli.Flag{
		cli.StringFlag{
			Name:  "region",
			Usage: "AWS Region",
		},
		cli.StringFlag{
			Name:     "profile",
			Required: false,
			Usage:    "AWS Profile to use",
		},
		cli.StringFlag{
			Name:     "role-arn",
			Required: false,
			Usage:    "Role Arn to Assume",
		},
		cli.StringFlag{
			Name:  "cluster",
			Usage: "Name of the cluster",
		},
		cli.StringFlag{
			Name:  "service",
			Usage: "Name of the service",
		},
		cli.StringFlag{
			Name:  "max-wait-count",
			Usage: "How much to wait , as per logic total wait time will be 2 * max-wait-count Seconds",
		},
	}

	app.Commands = []cli.Command{
		{
			Name:  "rollback",
			Usage: "Update the current service task defintion with the last successfull task definition id",
			Flags: appFlags,

			Action: func(c *cli.Context) {
				accessConfig := AccessConfig{}
				accessConfig.Region = c.String("region")
				if c.String("profile") != "" {
					accessConfig.Profile = c.String("profile")
				}
				if c.String("role-arn") != "" {
					accessConfig.RoleARN = c.String("role-arn")
				}

				ecsDeployClient.AccessConfig = accessConfig
				ecsDeployClient.NewClient()
				clusterName := c.String("cluster")
				serviceName := c.String("service")
				maxWaitCount := c.Int("max-wait-count")
				ecsDeployClient.Reconcile(clusterName, serviceName, maxWaitCount)
			},
		},
	}

	// start our application
	err := app.Run(os.Args)
	if err != nil {
		log.Fatal(err)
	}
}
