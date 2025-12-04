# Amazon ECS Workshop

**Format:** AWS Workshop Studio  
**Level:** Intermediate  
**Duration:** 2-3 hours  
**Status:** Production-ready Sample

## Overview

This workshop demonstrates how to create a modern workshop using AWS Workshop Studio format, with deep integration into the AWS ecosystem and advanced automation features.

### Purpose

- **Illustrate AWS Workshop Studio Structure** - Standard structure and organization
- **Showcase Modern Features** - Automation and AWS integration capabilities
- **Demonstrate Best Practices** - Professional workshop implementation
- **Provide Template Reference** - Foundation for new workshops

### Workshop Information

| Attribute | Details |
|-----------|---------|
| Format | AWS Workshop Studio |
| Topic | Amazon ECS & Containerization |
| Level | Intermediate |
| Duration | 2-3 hours |
| Estimated Cost | $5-10 USD (auto-tracked) |
| Status | Production-ready Sample |

## AWS Workshop Studio Structure

### Directory Structure

```
amazon-ecs-workshop/
├── workshop-config.json        # Workshop configuration (REQUIRED)
├── README.md                   # Workshop overview
├── content/                    # Workshop content
│   ├── index.md               # Homepage (REQUIRED)
│   ├── introduction/          # Introduction
│   │   └── index.md
│   ├── prerequisites/         # Prerequisites
│   │   └── index.md
│   ├── modules/              # Workshop modules
│   │   ├── module-1/
│   │   │   ├── index.md
│   │   │   ├── step-1.md
│   │   │   └── step-2.md
│   │   ├── module-2/
│   │   └── module-3/
│   ├── cleanup/              # Cleanup (REQUIRED)
│   │   └── index.md
│   └── conclusion/           # Conclusion
│       └── index.md
├── static/                   # Static assets
│   ├── images/
│   ├── css/
│   └── downloads/
├── templates/                # CloudFormation/CDK templates
│   ├── infrastructure.yaml
│   ├── iam-roles.yaml
│   └── cleanup.yaml
└── scripts/                  # Automation scripts
    ├── setup.sh
    ├── validate.sh
    └── cleanup.sh
```

### Key Features

**Advantages:**
- **AWS Native Integration** - Deep integration with AWS services
- **Auto Infrastructure** - Automatic resource provisioning
- **Cost Tracking** - Real-time cost monitoring
- **Auto Cleanup** - Automatic resource cleanup
- **Interactive Elements** - Rich UI components
- **Multi-region Support** - Deploy across AWS regions
- **Event Engine Integration** - Seamless event management
- **Analytics** - Built-in usage analytics

**Advanced Capabilities:**
- **CloudFormation Integration** - Infrastructure as Code
- **IAM Role Management** - Automatic permission setup
- **Resource Validation** - Pre/post checks
- **Progress Tracking** - User progress monitoring
- **Feedback Collection** - Built-in feedback system

## Workshop Configuration

### Complete Configuration Example (workshop-config.json)

```json
{
  "title": "Developing on Amazon ECS",
  "description": "Learn containerization with Amazon ECS, from basics to production deployment",
  "version": "1.0.0",
  "authors": [
    {
      "name": "AWS Workshop Team",
      "email": "workshop-team@amazon.com",
      "role": "Solutions Architect"
    }
  ],
  "level": "intermediate",
  "duration": "2-3 hours",
  "language": "en",
  "tags": ["containers", "ecs", "docker", "microservices", "devops"],
  "services": ["ECS", "ECR", "VPC", "ALB", "CloudFormation", "IAM"],
  "regions": ["us-east-1", "us-west-2", "eu-west-1", "ap-southeast-1"],
  "architecture": "x86_64",
  "cost_estimate": {
    "currency": "USD",
    "amount": 7.50,
    "description": "Estimated cost for 3-hour workshop including ECS Fargate, ALB, and ECR"
  },
  "auto_destroy": true,
  "cleanup_required": true,
  "prerequisites": [
    "AWS Account with appropriate permissions",
    "Basic understanding of containers and Docker",
    "Familiarity with AWS CLI",
    "Understanding of networking concepts"
  ],
  "learning_objectives": [
    "Deploy containerized applications using Amazon ECS",
    "Configure ECS clusters and services",
    "Implement load balancing with Application Load Balancer",
    "Apply container security best practices",
    "Set up monitoring and logging for containers"
  ],
  "infrastructure": {
    "cloudformation_template": "templates/infrastructure.yaml",
    "parameters": {
      "VpcCidr": "10.0.0.0/16",
      "ClusterName": "workshop-cluster"
    }
  },
  "validation": {
    "pre_workshop": "scripts/validate-prerequisites.sh",
    "post_module": "scripts/validate-module.sh",
    "cleanup": "scripts/validate-cleanup.sh"
  },
  "resources": {
    "max_instances": 10,
    "timeout_minutes": 180,
    "auto_stop": true
  },
  "integrations": {
    "cloud9": true,
    "cloudshell": true,
    "event_engine": true,
    "cost_explorer": true
  }
}
```

## AWS Workshop Studio Features

### 1. Automatic Infrastructure Provisioning

```yaml
# templates/infrastructure.yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'ECS Workshop Infrastructure'

Resources:
  ECSCluster:
    Type: AWS::ECS::Cluster
    Properties:
      ClusterName: !Sub '${AWS::StackName}-cluster'

  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      EnableDnsHostnames: true
      EnableDnsSupport: true
```

### 2. Interactive Content Elements

```markdown
<!-- Workshop Studio specific elements -->

{{< notice type="info" >}}
This creates an interactive info box
{{< /notice >}}

{{< tabs >}}
{{< tab "Console" >}}
AWS Console instructions
{{< /tab >}}
{{< tab "CLI" >}}
AWS CLI commands
{{< /tab >}}
{{< /tabs >}}

{{< expand "Click to see solution" >}}
Solution content here
{{< /expand >}}
```

### 3. Built-in Validation

```bash
#!/bin/bash
# scripts/validate-module.sh

echo "Validating ECS Service deployment..."

# Check if ECS service is running
SERVICE_STATUS=$(aws ecs describe-services \
  --cluster workshop-cluster \
  --services workshop-service \
  --query 'services[0].status' \
  --output text)

if [ "$SERVICE_STATUS" = "ACTIVE" ]; then
    echo "ECS Service is active"
else
    echo "ECS Service validation failed"
    exit 1
fi
```

### 4. Automatic Cost Tracking

- Real-time cost monitoring
- Budget alerts
- Resource usage tracking
- Cost optimization recommendations

### 5. Auto Cleanup System

```bash
#!/bin/bash
# scripts/cleanup.sh

echo "Starting automatic cleanup..."

# Stop ECS services
aws ecs update-service --cluster workshop-cluster --service workshop-service --desired-count 0
aws ecs delete-service --cluster workshop-cluster --service workshop-service

# Delete CloudFormation stack
aws cloudformation delete-stack --stack-name workshop-infrastructure

echo "Cleanup completed"
```

## Running the Workshop

### Option 1: AWS Workshop Studio Platform

```bash
# Upload workshop to AWS Workshop Studio
# Platform automatically:
# 1. Parses workshop-config.json
# 2. Provisions infrastructure
# 3. Sets up monitoring
# 4. Enables cost tracking
```

### Option 2: Local Development

```bash
# Clone repository
git clone https://github.com/aws-samples/workshop-studio.git
cd workshop-studio/amazon-ecs-workshop

# Validate configuration
python3 -c "import json; json.load(open('workshop-config.json'))"

# Start local server
python3 -m http.server 8080
```

### Option 3: AWS Event Engine

```bash
# Workshop Studio automatically integrates with Event Engine
# Participants receive:
# - Pre-configured AWS accounts
# - Automatic resource provisioning
# - Cost tracking per participant
# - Automatic cleanup after event
```

## Monitoring and Analytics

### Built-in Analytics

- **Participant Progress** - Real-time tracking
- **Completion Rates** - Module-by-module analysis
- **Time Spent** - Per module timing
- **Error Rates** - Common failure points
- **Feedback Scores** - Participant satisfaction

### Cost Analytics

- **Real-time Costs** - Live cost tracking
- **Resource Utilization** - Efficiency metrics
- **Budget Alerts** - Automatic notifications
- **Cost Optimization** - Recommendations

## Comparison with Hugo Format

| Feature | Hugo Workshop | AWS Workshop Studio |
|---------|---------------|---------------------|
| Setup Time | 2-3 hours | 15 minutes |
| Infrastructure | Manual setup | Auto-provisioned |
| Cost Tracking | None | Real-time |
| Cleanup | Manual scripts | Automatic |
| Monitoring | None | Built-in analytics |
| Validation | Manual | Automated |
| Multi-region | Complex | Native support |
| Event Integration | None | Event Engine ready |
| Participant Management | None | Full management |
| Feedback Collection | Manual | Automated |

## Security and Best Practices

### Security Features

```json
{
  "security": {
    "iam_roles": "least_privilege",
    "network_isolation": true,
    "encryption_at_rest": true,
    "encryption_in_transit": true,
    "vulnerability_scanning": true
  }
}
```

### Best Practices Implementation

- **Least Privilege IAM** - Automatic role creation
- **Network Isolation** - VPC with private subnets
- **Resource Tagging** - Automatic tagging for cost allocation
- **Monitoring** - CloudWatch integration
- **Backup** - Automatic snapshots where applicable

## Advanced Features

### 1. Multi-language Support

```json
{
  "languages": ["en", "ja", "ko", "zh"],
  "default_language": "en"
}
```

### 2. Adaptive Learning

```json
{
  "adaptive_learning": {
    "skill_assessment": true,
    "personalized_path": true,
    "difficulty_adjustment": true
  }
}
```

### 3. Integration Ecosystem

```json
{
  "integrations": {
    "github": "source_control",
    "slack": "notifications",
    "teams": "collaboration",
    "jira": "issue_tracking"
  }
}
```

## Migration from Hugo

If you have a Hugo workshop, follow this migration process:

### 1. Structure Conversion

```bash
# Use migration tool
./migrate-hugo-to-workshop-studio.sh hugo-workshop workshop-studio-output
```

### 2. Configuration Mapping

```bash
# Hugo config.toml → workshop-config.json
# Hugo frontmatter → Workshop Studio metadata
# Hugo shortcodes → Workshop Studio components
```

### 3. Feature Enhancement

- Add infrastructure templates
- Implement validation scripts
- Configure cost tracking
- Setup auto-cleanup

## Resources and Documentation

### AWS Workshop Studio Resources

- [AWS Workshop Studio Documentation](https://docs.aws.amazon.com/workshop-studio/)
- [Workshop Studio Best Practices](https://aws.amazon.com/workshops/best-practices/)
- [Community Workshops](https://workshops.aws/)

### Development Tools

- [Workshop Studio CLI](https://github.com/aws/workshop-studio-cli)
- [Validation Tools](https://github.com/aws/workshop-validation-tools)
- [Template Library](https://github.com/aws/workshop-templates)

## Conclusion

AWS Workshop Studio format provides:

**Immediate Benefits:**
- Faster workshop development
- Automatic AWS integration
- Built-in cost management
- Professional presentation

**Long-term Advantages:**
- Scalable workshop delivery
- Rich analytics and insights
- Community sharing capabilities
- Continuous improvement through feedback

**Business Impact:**
- Reduced operational overhead
- Improved participant experience
- Better cost control
- Enhanced learning outcomes

**Recommendation:** Use AWS Workshop Studio format for all new workshops to fully leverage the AWS ecosystem and modern workshop capabilities.

---

**Note:** This workshop demonstrates AWS Workshop Studio format and best practices. Compare with the AWS CLI Workshop to see the differences from Hugo format.

**Status:** Ready for production deployment on AWS Workshop Studio platform.
