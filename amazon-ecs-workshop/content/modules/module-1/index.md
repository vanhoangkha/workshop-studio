# Module 1: Setting Up Your ECS Cluster

In this module, you'll create an Amazon ECS cluster using AWS Fargate and set up the foundational infrastructure for deploying containerized applications.

## Learning Objectives

By the end of this module, you will:

- Understand ECS cluster architecture
- Create an ECS cluster using AWS Fargate
- Configure VPC and networking for ECS
- Set up IAM roles for ECS tasks
- Verify cluster creation and readiness

## Architecture Overview

In this module, we'll create:

- **ECS Cluster**: The logical grouping for your containerized services
- **VPC**: Isolated network environment with public and private subnets
- **Security Groups**: Network access controls for your containers
- **IAM Roles**: Permissions for ECS tasks and services

## Step 1: Create VPC for ECS

First, create a VPC with public and private subnets:

```bash
# Create VPC
aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=ecs-workshop-vpc}]'

# Save VPC ID
VPC_ID=$(aws ec2 describe-vpcs \
    --filters "Name=tag:Name,Values=ecs-workshop-vpc" \
    --query 'Vpcs[0].VpcId' \
    --output text)

echo "VPC ID: $VPC_ID"
```

Create subnets:

```bash
# Create public subnet
aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.1.0/24 \
    --availability-zone us-east-1a \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=ecs-public-subnet-1}]'

# Create private subnet
aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.2.0/24 \
    --availability-zone us-east-1a \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=ecs-private-subnet-1}]'
```

## Step 2: Create ECS Cluster

Create an ECS cluster using Fargate:

```bash
aws ecs create-cluster \
    --cluster-name workshop-cluster \
    --capacity-providers FARGATE FARGATE_SPOT \
    --default-capacity-provider-strategy \
        capacityProvider=FARGATE,weight=1 \
        capacityProvider=FARGATE_SPOT,weight=1 \
    --tags key=Environment,value=workshop
```

Verify cluster creation:

```bash
aws ecs describe-clusters \
    --clusters workshop-cluster \
    --query 'clusters[0].[clusterName,status,registeredContainerInstancesCount]' \
    --output table
```

Expected output:
```
---------------------------------
|      DescribeClusters         |
+------------------+------------+
|  workshop-cluster|  ACTIVE   |
|  0               |           |
+------------------+------------+
```

## Step 3: Create IAM Roles

Create task execution role:

```bash
# Create trust policy
cat > ecs-task-trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create role
aws iam create-role \
    --role-name ecsTaskExecutionRole \
    --assume-role-policy-document file://ecs-task-trust-policy.json

# Attach managed policy
aws iam attach-role-policy \
    --role-name ecsTaskExecutionRole \
    --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
```

## Step 4: Create Security Group

Create security group for ECS tasks:

```bash
# Create security group
SG_ID=$(aws ec2 create-security-group \
    --group-name ecs-tasks-sg \
    --description "Security group for ECS tasks" \
    --vpc-id $VPC_ID \
    --query 'GroupId' \
    --output text)

# Allow HTTP traffic
aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

# Allow HTTPS traffic
aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0

echo "Security Group ID: $SG_ID"
```

## Step 5: Verify Setup

Check all resources are created:

```bash
# Check cluster
aws ecs list-clusters

# Check VPC
aws ec2 describe-vpcs --vpc-ids $VPC_ID

# Check IAM role
aws iam get-role --role-name ecsTaskExecutionRole

# Check security group
aws ec2 describe-security-groups --group-ids $SG_ID
```

## Validation

Your ECS cluster setup is complete when:

- ✅ ECS cluster status is `ACTIVE`
- ✅ VPC and subnets are created
- ✅ IAM role `ecsTaskExecutionRole` exists
- ✅ Security group allows HTTP/HTTPS traffic

## Troubleshooting

**Issue**: Cluster creation fails
- **Solution**: Check IAM permissions, ensure you have `ecs:CreateCluster` permission

**Issue**: VPC creation fails
- **Solution**: Check if you've reached VPC limit (default: 5 per region)

**Issue**: IAM role already exists
- **Solution**: Use existing role or choose different name

## Cost Tracking

Resources created in this module:

- ECS Cluster: No charge (pay only for running tasks)
- VPC: No charge
- IAM Role: No charge
- Security Group: No charge

## Cleanup (Optional)

To remove resources from this module:

```bash
# Delete cluster
aws ecs delete-cluster --cluster workshop-cluster

# Delete security group
aws ec2 delete-security-group --group-id $SG_ID

# Delete IAM role
aws iam detach-role-policy \
    --role-name ecsTaskExecutionRole \
    --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
aws iam delete-role --role-name ecsTaskExecutionRole
```

## Next Steps

Now that your ECS cluster is ready, proceed to Module 2 where you'll build and deploy your first containerized application.

## Additional Resources

- [Amazon ECS Clusters](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/clusters.html)
- [AWS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html)
- [ECS Task Execution IAM Role](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html)
