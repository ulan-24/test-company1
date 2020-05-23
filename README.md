# test-company1

This module will create AWS VPC with the following resources and specifications.
Multiple public and private subnets will be created, not limited to azs, you can create as many as you want.
Single internet gateway will be created for public subnets.
One nat gateway will be created for each availability zone for high availability and fault tolerance.
Every resource will be tagged with "project" and "environment", so that they can be tracked by monitoring tools.
Tags will also be used in naming schema. This will make navigating through your resources easier.