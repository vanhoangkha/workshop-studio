#  AWS WORKSHOP STUDIO DEVELOPMENT GUIDE

##  Table of Contents
1. [AWS Workshop Studio Overview](#1-aws-workshop-studio-overview)
2. [Development Environment Setup](#2-development-environment-setup)
3. [Workshop Design and Planning](#3-workshop-design-and-planning)
4. [Workshop Structure Creation](#4-workshop-structure-creation)
5. [Content Development](#5-content-development)
6. [Infrastructure Setup](#6-infrastructure-setup)
7. [Testing and Validation](#7-testing-and-validation)
8. [Deployment and Publishing](#8-deployment-and-publishing)
9. [Monitoring and Maintenance](#9-monitoring-and-maintenance)
10. [Best Practices and Optimization](#10-best-practices-and-optimization)

---

## 1. AWS Workshop Studio Overview

### 1.1 What is AWS Workshop Studio?

AWS Workshop Studio is AWS's modern platform for creating, managing, and deploying interactive workshops. Unlike traditional Hugo format, Workshop Studio provides:

**Key Features:**
- **Automatic Infrastructure Management**: Auto-provisioning and cleanup
- **Cost Tracking**: Real-time cost monitoring
- **Interactive Elements**: Rich UI components
- **Analytics Dashboard**: Detailed participant insights
- **Multi-region Support**: Deploy across AWS regions

**Comparison with Hugo Format:**

| Criteria | Hugo Format | AWS Workshop Studio |
|----------|-------------|-------------------|
| Setup Time | 2-3 days | 4-6 hours |
| AWS Integration | Manual | Native |
| Cost Management | Manual tracking | Real-time monitoring |
| Infrastructure | Manual CloudFormation | Auto-provisioned |
| Maintenance | High | Low (AWS managed) |

### 1.2 Workshop Studio Architecture

```
AWS Workshop Studio Architecture
┌─────────────────────────────────────────────────────────────┐
│                    Workshop Studio Platform                 │
├─────────────────────────────────────────────────────────────┤
│  Frontend Layer                                             │
│  ├── Interactive UI Components                              │
│  ├── Progress Tracking                                      │
│  ├── Real-time Validation                                   │
│  └── Responsive Design                                      │
├─────────────────────────────────────────────────────────────┤
│  Management Layer                                           │
│  ├── Event Engine Integration                               │
│  ├── Cost Tracking & Alerts                                │
│  ├── Analytics & Reporting                                  │
│  └── Multi-region Orchestration                            │
├─────────────────────────────────────────────────────────────┤
│  Infrastructure Layer                                       │
│  ├── Auto-provisioning (CloudFormation/CDK)               │
│  ├── Resource Lifecycle Management                          │
│  ├── Security & Compliance                                  │
│  └── Automatic Cleanup                                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Development Environment Setup

### 2.1 Prerequisites

**Required Tools:**
```bash
# AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Git
sudo apt-get install git

# Text editor (VS Code recommended)
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code
```

**AWS Account Setup:**
```bash
# Configure AWS credentials
aws configure
# AWS Access Key ID: [Your Access Key]
# AWS Secret Access Key: [Your Secret Key]
# Default region name: us-east-1
# Default output format: json

# Verify configuration
aws sts get-caller-identity
```

**Workspace Setup:**
```bash
# Create workspace directory
mkdir -p ~/aws-workshop-development
cd ~/aws-workshop-development

# Clone template repository
git clone https://github.com/vanhoangkha/workshop-studio.git
cd workshop-studio
```

### 2.2 Development Environment

**VS Code Extensions:**
```json
{
  "recommendations": [
    "ms-vscode.vscode-json",
    "redhat.vscode-yaml",
    "ms-python.python",
    "amazonwebservices.aws-toolkit-vscode",
    "ms-vscode.markdown-preview-enhanced",
    "streetsidesoftware.code-spell-checker"
  ]
}
```

**Project Structure Template:**
```
my-workshop/
├── .vscode/                    # VS Code configuration
│   ├── settings.json
│   ├── extensions.json
│   └── launch.json
├── workshop-config.json        # Workshop configuration (CORE)
├── content/                    # Workshop content
│   ├── index.md               # Homepage
│   ├── introduction/          # Workshop overview
│   ├── prerequisites/         # Setup requirements
│   ├── modules/              # Learning modules
│   ├── cleanup/              # Resource cleanup
│   └── conclusion/           # Next steps
├── static/                    # Static assets
│   ├── images/               # Workshop images
│   ├── diagrams/             # Architecture diagrams
│   └── downloads/            # Downloadable files
├── templates/                 # Infrastructure templates
│   ├── infrastructure.yaml   # Main CloudFormation
│   ├── iam-roles.yaml       # IAM configurations
│   └── networking.yaml      # VPC and networking
├── scripts/                   # Automation scripts
│   ├── validate-prerequisites.sh
│   ├── validate-module.sh
│   └── cleanup.sh
├── tests/                     # Testing files
│   ├── unit/                 # Unit tests
│   └── integration/          # Integration tests
└── docs/                      # Additional documentation
    ├── DEVELOPMENT.md
    ├── DEPLOYMENT.md
    └── TROUBLESHOOTING.md
```

---

## 3. Workshop Design and Planning

### 3.1 Workshop Planning Framework

**Define Learning Objectives:**
```markdown
## Learning Objectives Template

### Primary Objectives (Must achieve):
- [ ] Objective 1: Specific, measurable outcome
- [ ] Objective 2: Hands-on skill development
- [ ] Objective 3: Real-world application

### Secondary Objectives (Nice to have):
- [ ] Advanced feature exploration
- [ ] Best practices understanding
- [ ] Troubleshooting skills

### Success Metrics:
- Completion rate target: 85%
- Average time: 2-3 hours
- Satisfaction score: 4.5/5
```

**Audience Analysis:**
```json
{
  "target_audience": {
    "primary": {
      "role": "Cloud Engineers, DevOps Engineers",
      "experience_level": "Intermediate",
      "aws_knowledge": "Basic to Intermediate",
      "prerequisites": [
        "Basic AWS console navigation",
        "Understanding of cloud concepts",
        "Command line familiarity"
      ]
    },
    "secondary": {
      "role": "Solutions Architects, Developers",
      "experience_level": "Beginner to Advanced",
      "adaptations": [
        "Optional advanced sections",
        "Alternative implementation paths",
        "Extended troubleshooting guides"
      ]
    }
  }
}
```

### 3.2 Content Architecture Design

**Module Structure Planning:**
```
Workshop Flow Design
┌─────────────────────────────────────────────────────────────┐
│  Introduction (15 min)                                      │
│  ├── Welcome & Objectives                                   │
│  ├── Architecture Overview                                  │
│  └── Workshop Environment Setup                             │
├─────────────────────────────────────────────────────────────┤
│  Prerequisites (20 min)                                     │
│  ├── Account Setup Verification                             │
│  ├── Required Tools Installation                            │
│  └── Initial Environment Validation                         │
├─────────────────────────────────────────────────────────────┤
│  Module 1: Foundation (30 min)                             │
│  ├── Core Concepts Introduction                             │
│  ├── Hands-on Exercise 1                                   │
│  └── Validation & Checkpoint                               │
├─────────────────────────────────────────────────────────────┤
│  Module 2: Implementation (45 min)                         │
│  ├── Advanced Configuration                                 │
│  ├── Hands-on Exercise 2                                   │
│  └── Testing & Verification                                │
├─────────────────────────────────────────────────────────────┤
│  Module 3: Integration (30 min)                            │
│  ├── Service Integration                                    │
│  ├── End-to-end Testing                                    │
│  └── Performance Optimization                              │
├─────────────────────────────────────────────────────────────┤
│  Cleanup (15 min)                                          │
│  ├── Resource Cleanup Verification                          │
│  ├── Cost Review                                           │
│  └── Next Steps                                            │
└─────────────────────────────────────────────────────────────┘
```

### 3.3 Cost Planning and Estimation

**Cost Analysis Framework:**
```json
{
  "cost_estimation": {
    "target_cost_per_participant": "$5-10 USD",
    "cost_breakdown": {
      "compute": {
        "service": "EC2 t3.micro",
        "duration": "3 hours",
        "estimated_cost": "$0.50"
      },
      "storage": {
        "service": "S3 Standard",
        "data_size": "1 GB",
        "estimated_cost": "$0.10"
      },
      "networking": {
        "service": "Data Transfer",
        "estimated_cost": "$0.20"
      },
      "other_services": {
        "lambda_invocations": "$0.10",
        "api_gateway_calls": "$0.05",
        "cloudwatch_logs": "$0.05"
      }
    },
    "cost_optimization_strategies": [
      "Use t3.micro instances (free tier eligible)",
      "Implement automatic shutdown after 4 hours",
      "Use spot instances where applicable",
      "Optimize data transfer patterns"
    ]
  }
}
```

---

## 4. Workshop Structure Creation

### 4.1 Workshop Configuration (workshop-config.json)

This is the core file of AWS Workshop Studio:

```json
{
  "title": "Amazon ECS Container Workshop",
  "description": "Comprehensive hands-on workshop covering Amazon ECS, containerization, and microservices architecture on AWS",
  "version": "2.1.0",
  "level": "intermediate",
  "duration": "2-3 hours",
  "language": "en",
  "tags": ["containers", "ecs", "docker", "microservices", "aws"],

  "cost_estimate": {
    "currency": "USD",
    "amount": 8.50,
    "description": "Estimated cost for 3-hour workshop including EC2, ECS, and supporting services"
  },

  "auto_destroy": true,
  "auto_destroy_timeout": 240,

  "services": [
    "Amazon ECS",
    "Amazon ECR",
    "Amazon VPC",
    "Application Load Balancer",
    "AWS CloudFormation",
    "Amazon CloudWatch"
  ],

  "regions": [
    "us-east-1",
    "us-west-2",
    "eu-west-1",
    "ap-southeast-1"
  ],

  "infrastructure": {
    "cloudformation_template": "templates/infrastructure.yaml",
    "parameters": {
      "EnvironmentName": "ECSWorkshop",
      "InstanceType": "t3.micro",
      "KeyPairName": "workshop-keypair"
    }
  },

  "validation": {
    "pre_workshop": "scripts/validate-prerequisites.sh",
    "post_module": "scripts/validate-module.sh",
    "cleanup_verification": "scripts/verify-cleanup.sh"
  },

  "features": {
    "progress_tracking": true,
    "cost_tracking": true,
    "feedback_collection": true,
    "analytics": true,
    "multi_language": false
  },

  "support": {
    "documentation_url": "https://github.com/your-org/ecs-workshop",
    "issues_url": "https://github.com/your-org/ecs-workshop/issues",
    "contact_email": "workshop-support@yourorg.com"
  }
}
```

### 4.2 Content Structure Setup

**Homepage (content/index.md):**
```markdown
---
title: "Amazon ECS Container Workshop"
description: "Learn containerization and microservices with Amazon ECS"
---

# Amazon ECS Container Workshop

![ECS Workshop Architecture](../static/images/ecs-architecture-overview.png)

##  Workshop Overview

Welcome to the Amazon ECS Container Workshop! In this hands-on session, you'll learn how to:

- Deploy containerized applications using Amazon ECS
- Set up container registries with Amazon ECR
- Configure load balancing and service discovery
- Implement monitoring and logging best practices
- Optimize container performance and costs

##  Architecture

You'll build a complete microservices architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                    Internet Gateway                         │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                Application Load Balancer                    │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                    ECS Cluster                              │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │   Web Service   │    │   API Service   │                │
│  │   (Fargate)     │    │   (Fargate)     │                │
│  └─────────────────┘    └─────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

## Duration
**Estimated Time:** 2-3 hours

## Cost
**Estimated Cost:** $8.50 USD (automatically tracked)

##  Prerequisites
- Basic AWS Console familiarity
- Understanding of containerization concepts
- Command line experience

##  Ready to Start?

Click **Next** to begin with the prerequisites setup!

---
**Tip:** This workshop uses automatic resource cleanup to prevent unexpected charges.
```

**Prerequisites (content/prerequisites/index.md):**
```markdown
---
title: "Prerequisites & Setup"
weight: 10
---

# Prerequisites & Setup

##  Required Tools

### 1. AWS CLI v2
```bash
# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify installation
aws --version
```

### 2. Docker
```bash
# Install Docker
sudo apt-get update
sudo apt-get install docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify installation
docker --version
```

### 3. AWS Account Requirements

 **Account Permissions:**
- EC2 full access
- ECS full access
- ECR full access
- VPC management
- IAM role creation
- CloudFormation access

 **Service Limits:**
- EC2 instances: Minimum 2 t3.micro
- VPC: 1 additional VPC
- ECS clusters: 1 cluster

##  Environment Validation

Run this validation script to ensure your environment is ready:

```bash
#!/bin/bash
# validate-environment.sh

echo " Validating AWS Workshop Environment..."

# Check AWS CLI
if ! command -v aws &> /dev/null; then
    echo " AWS CLI not found. Please install AWS CLI v2"
    exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    echo " AWS credentials not configured"
    exit 1
fi

# Check Docker
if ! command -v docker &> /dev/null; then
    echo " Docker not found. Please install Docker"
    exit 1
fi

# Check Docker daemon
if ! docker info &> /dev/null; then
    echo " Docker daemon not running"
    exit 1
fi

echo " Environment validation successful!"
echo " Ready to proceed with the workshop"
```

## Region Selection

This workshop supports multiple regions:
- **us-east-1** (N. Virginia) - Recommended
- **us-west-2** (Oregon)
- **eu-west-1** (Ireland)
- **ap-southeast-1** (Singapore)

**Note:** Ensure you're working in your selected region throughout the workshop.

##  Validation Checklist

Before proceeding, verify:

- [ ] AWS CLI v2 installed and configured
- [ ] Docker installed and running
- [ ] AWS account has required permissions
- [ ] Selected AWS region
- [ ] Validation script passed

---

**Next Step:** Once validation is complete, proceed to Module 1!
```

I'll continue with the remaining parts in the next file...
