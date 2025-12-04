# Prerequisites

Before starting this workshop, ensure you have the following prerequisites in place.

## AWS Account Requirements

- **AWS Account**: You need an AWS account with appropriate permissions to create and manage:
  - Amazon ECS clusters and services
  - Amazon ECR repositories
  - VPC, subnets, and security groups
  - Application Load Balancers
  - IAM roles and policies
  - CloudFormation stacks

- **IAM Permissions**: Your IAM user or role should have permissions equivalent to:
  - `AmazonECS_FullAccess`
  - `AmazonEC2ContainerRegistryFullAccess`
  - `IAMFullAccess` (for creating service roles)
  - `AWSCloudFormationFullAccess`

## Technical Requirements

### Local Development Environment

1. **AWS CLI v2**
   - Install from: https://aws.amazon.com/cli/
   - Verify installation:
   ```bash
   aws --version
   # Should show: aws-cli/2.x.x or higher
   ```

2. **Docker**
   - Install Docker Desktop or Docker Engine
   - Verify installation:
   ```bash
   docker --version
   # Should show: Docker version 20.x or higher
   ```

3. **Git**
   - Install from: https://git-scm.com/
   - Verify installation:
   ```bash
   git --version
   ```

4. **Text Editor or IDE**
   - VS Code, IntelliJ, or any preferred editor
   - Recommended: VS Code with Docker extension

### AWS CLI Configuration

Configure your AWS CLI with credentials:

```bash
aws configure
```

Provide:
- AWS Access Key ID
- AWS Secret Access Key
- Default region: `us-east-1` (recommended for this workshop)
- Default output format: `json`

Verify configuration:
```bash
aws sts get-caller-identity
```

## Knowledge Prerequisites

### Required Knowledge

- **Basic AWS concepts**: Understanding of AWS regions, availability zones, and basic services
- **Container fundamentals**: Basic understanding of containers and Docker
- **Networking basics**: Understanding of VPCs, subnets, security groups, and load balancers
- **Command line proficiency**: Comfortable using terminal/command prompt

### Recommended Knowledge

- Experience with microservices architecture
- Familiarity with CI/CD concepts
- Basic understanding of infrastructure as code

## Cost Considerations

This workshop will incur AWS charges. Estimated costs:

- **ECS Fargate tasks**: ~$0.04 per vCPU per hour + $0.004 per GB memory per hour
- **Application Load Balancer**: ~$0.0225 per hour + data processing charges
- **ECR storage**: First 500 MB free, then $0.10 per GB per month
- **Data transfer**: Varies by region

**Estimated total cost**: $5-10 USD for completing the workshop (2-3 hours)

**Important**: Remember to clean up all resources after completing the workshop to avoid ongoing charges.

## Verification Checklist

Before proceeding, verify you have:

- [ ] AWS account with appropriate permissions
- [ ] AWS CLI v2 installed and configured
- [ ] Docker installed and running
- [ ] Git installed
- [ ] Text editor ready
- [ ] Understanding of basic AWS and container concepts
- [ ] Awareness of potential costs

## Getting Help

If you encounter issues with prerequisites:

- **AWS CLI issues**: Check [AWS CLI documentation](https://docs.aws.amazon.com/cli/)
- **Docker issues**: Check [Docker documentation](https://docs.docker.com/)
- **AWS permissions**: Contact your AWS administrator
- **Workshop issues**: Open an issue in the workshop repository

## Next Steps

Once you've verified all prerequisites, continue to [Module 1: Setting Up ECS Cluster](../modules/module-1/).
