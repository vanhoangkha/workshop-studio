# Developing on Amazon ECS

## Overview
Welcome to the "Developing on Amazon ECS" workshop! In this hands-on workshop, you will learn how to develop, deploy, and manage containerized applications using Amazon Elastic Container Service (ECS). You'll build a complete microservices architecture and deploy it to a production-ready ECS cluster.

## Learning Objectives
By the end of this workshop, you will be able to:
- Set up and configure an Amazon ECS cluster
- Create and manage ECS task definitions and services
- Deploy containerized applications to ECS
- Configure load balancing and service discovery
- Implement CI/CD pipelines for ECS applications
- Monitor and troubleshoot ECS workloads

## Prerequisites
- AWS Account with appropriate permissions
- Basic knowledge of containers and Docker
- Familiarity with AWS CLI
- Understanding of networking concepts
- Text editor (VS Code recommended)

## Architecture
In this workshop, you will build the following architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                        Internet Gateway                      │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────┴───────────────────────────────────────┐
│                    Application Load Balancer                │
└─────────────────┬───────────────────┬───────────────────────┘
                  │                   │
        ┌─────────┴─────────┐ ┌───────┴─────────┐
        │   Public Subnet   │ │  Public Subnet  │
        │      AZ-1a        │ │      AZ-1b      │
        └─────────┬─────────┘ └───────┬─────────┘
                  │                   │
        ┌─────────┴─────────┐ ┌───────┴─────────┐
        │  Private Subnet   │ │ Private Subnet  │
        │      AZ-1a        │ │      AZ-1b      │
        │                   │ │                 │
        │  ┌─────────────┐  │ │ ┌─────────────┐ │
        │  │ ECS Service │  │ │ │ ECS Service │ │
        │  │   Tasks     │  │ │ │   Tasks     │ │
        │  └─────────────┘  │ │ └─────────────┘ │
        └───────────────────┘ └─────────────────┘
```

## Workshop Modules

1. **[Introduction](introduction/)** - Overview of Amazon ECS and containerization
2. **[Prerequisites](prerequisites/)** - Setting up your development environment
3. **[Module 1: Infrastructure Setup](modules/module-1/)** - Creating VPC, subnets, and ECS cluster
4. **[Module 2: Application Deployment](modules/module-2/)** - Deploying your first containerized application
5. **[Module 3: Advanced Features](modules/module-3/)** - Service discovery, auto-scaling, and monitoring
6. **[Cleanup](cleanup/)** - Removing all created resources

## Estimated Duration
**2-3 hours** (depending on your experience level)

## Estimated Cost
**$5-10 USD** (assuming you complete the workshop within the estimated time and clean up resources afterward)

## Support
If you encounter any issues during this workshop, please:
1. Check the troubleshooting section in each module
2. Review the AWS documentation links provided
3. Contact the workshop facilitator if in a guided session

## Let's Get Started!
Ready to dive into Amazon ECS? Let's start with the [Introduction](introduction/) to understand the fundamentals.
