# 🐳 Developing on Amazon ECS Workshop

Learn how to develop, deploy, and manage containerized applications using Amazon Elastic Container Service (ECS) with hands-on exercises covering container orchestration, service deployment, and DevOps best practices.

## 📋 Workshop Overview

This intermediate-level workshop provides comprehensive hands-on experience with Amazon ECS, teaching you how to containerize applications, manage container orchestration, and implement production-ready deployment strategies using AWS container services.

### 🎯 Learning Objectives

By the end of this workshop, you will be able to:

- ✅ Understand container fundamentals and Docker basics
- ✅ Set up and configure Amazon ECS clusters
- ✅ Create and manage ECS task definitions and services
- ✅ Deploy containerized applications using ECS
- ✅ Configure Application Load Balancers for container services
- ✅ Implement auto-scaling for containerized applications
- ✅ Monitor and troubleshoot ECS deployments
- ✅ Apply container security best practices
- ✅ Integrate ECS with CI/CD pipelines

### 📊 Workshop Details

| **Attribute** | **Details** |
|---------------|-------------|
| **Level** | Intermediate |
| **Duration** | 2-3 hours |
| **Cost** | $5-10 USD (estimated) |
| **Language** | English |
| **Region** | us-east-1 (primary) |

### 🛠️ AWS Services Covered

- **Amazon ECS** - Elastic Container Service
- **Amazon ECR** - Elastic Container Registry
- **Application Load Balancer** - Traffic distribution
- **VPC** - Virtual Private Cloud networking
- **CloudFormation** - Infrastructure as Code
- **IAM** - Identity and Access Management
- **CloudWatch** - Monitoring and logging

## 🏗️ Workshop Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                Amazon ECS Workshop Architecture             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐    ┌─────────────────────────────────────┐ │
│  │   Internet  │    │              VPC                    │ │
│  │   Gateway   │◄──►│  ┌─────────────┐ ┌─────────────┐   │ │
│  └─────────────┘    │  │Public Subnet│ │Public Subnet│   │ │
│                     │  │     AZ-a    │ │     AZ-b    │   │ │
│  ┌─────────────┐    │  └─────────────┘ └─────────────┘   │ │
│  │Application  │    │         │               │          │ │
│  │Load Balancer│◄───┼─────────┼───────────────┼──────────┤ │
│  └─────────────┘    │         ▼               ▼          │ │
│                     │  ┌─────────────┐ ┌─────────────┐   │ │
│  ┌─────────────┐    │  │   ECS       │ │   ECS       │   │ │
│  │   ECR       │    │  │  Service    │ │  Service    │   │ │
│  │ Repository  │◄───┼──│  (Tasks)    │ │  (Tasks)    │   │ │
│  └─────────────┘    │  └─────────────┘ └─────────────┘   │ │
│                     │                                     │ │
│  ┌─────────────┐    │  ┌─────────────────────────────────┐ │
│  │ CloudWatch  │◄───┼──│         ECS Cluster             │ │
│  │   Logs      │    │  └─────────────────────────────────┘ │
│  └─────────────┘    └─────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 📚 Workshop Modules

### Module 1: Container Fundamentals & ECS Setup (45 minutes)
**Container Basics & ECS Introduction**
- Understanding containers vs virtual machines
- Docker fundamentals and best practices
- Introduction to Amazon ECS concepts
- Setting up ECS cluster and basic configuration

**Key Topics:**
- Container lifecycle and management
- ECS cluster types (EC2 vs Fargate)
- Task definitions and container specifications
- ECS service discovery and networking

### Module 2: Application Deployment & Service Management (60 minutes)
**Deploying Containerized Applications**
- Creating and configuring task definitions
- Deploying services with load balancing
- Managing service updates and rollbacks
- Implementing health checks and monitoring

**Key Topics:**
- ECR repository setup and image management
- Service deployment strategies
- Application Load Balancer integration
- Auto-scaling configuration

### Module 3: Advanced ECS Features & Best Practices (45 minutes)
**Production-Ready Deployments**
- Security best practices for containers
- Monitoring and logging with CloudWatch
- CI/CD integration patterns
- Cost optimization strategies

**Key Topics:**
- Container security scanning
- Secrets management with AWS Systems Manager
- Blue/green deployments
- Performance monitoring and optimization

## 📋 Prerequisites

### 🔐 AWS Account Requirements
- [ ] AWS Account with administrative access or ECS-specific permissions
- [ ] Credit card on file (estimated cost: $5-10 for workshop duration)
- [ ] Access to create VPC, ECS clusters, and load balancers

### 💻 Local Environment
- [ ] **Operating System**: Windows 10+, macOS 10.14+, or Linux
- [ ] **Docker Desktop**: Latest version installed and running
- [ ] **AWS CLI**: Version 2.x installed and configured
- [ ] **Git**: For cloning repositories
- [ ] **Text Editor**: VS Code with Docker extension recommended

### 📚 Knowledge Prerequisites
- [ ] **Intermediate AWS knowledge**: Understanding of VPC, EC2, and IAM
- [ ] **Basic container concepts**: Familiarity with Docker and containerization
- [ ] **Command line proficiency**: Comfortable with terminal/command prompt
- [ ] **Networking basics**: Understanding of load balancers and DNS
- [ ] **JSON/YAML**: Basic understanding for configuration files

### ✅ Pre-Workshop Validation

Verify your environment setup:

```bash
# Check Docker installation
docker --version
docker run hello-world

# Verify AWS CLI configuration
aws --version
aws sts get-caller-identity

# Test Git installation
git --version

# Check available resources (optional)
aws ecs describe-clusters
aws ec2 describe-vpcs --query 'Vpcs[?IsDefault==`true`]'
```

## 🚀 Getting Started

### Option 1: Run Locally
```bash
# Clone the repository
git clone https://github.com/vanhoangkha/workshop-studio.git
cd workshop-studio/amazon-ecs-workshop

# Start local development server
python3 -m http.server 8080

# Access workshop at http://localhost:8080
```

### Option 2: AWS Workshop Studio
1. Navigate to [AWS Workshop Studio](https://workshops.aws/)
2. Search for "Developing on Amazon ECS"
3. Follow the guided setup and provisioning process

### Option 3: Self-Paced Learning
1. Review the prerequisites and setup requirements
2. Follow the module sequence in the content directory
3. Use the provided CloudFormation templates for infrastructure

## 💰 Cost Breakdown

| **Service** | **Usage** | **Estimated Cost** |
|-------------|-----------|-------------------|
| **ECS Fargate** | 2-3 hours of task execution | $2.00 - $4.00 |
| **Application Load Balancer** | 2-3 hours | $0.50 - $1.00 |
| **ECR** | Image storage and transfers | $0.10 - $0.50 |
| **VPC & Networking** | Data transfer | $0.25 - $0.50 |
| **CloudWatch** | Logs and monitoring | $0.10 - $0.25 |
| **Other Services** | IAM, CloudFormation | Free |
| **Total** | | **$5.00 - $10.00** |

> **💡 Cost Optimization Tips:**
> - Use Fargate Spot for development workloads
> - Clean up resources immediately after workshop
> - Monitor usage through AWS Cost Explorer
> - Leverage AWS Free Tier where applicable

## 🛡️ Security Considerations

### Container Security Best Practices
- **Image Scanning**: Enable ECR vulnerability scanning
- **Least Privilege**: Use minimal IAM permissions
- **Network Security**: Implement proper VPC security groups
- **Secrets Management**: Use AWS Systems Manager Parameter Store
- **Runtime Security**: Monitor container behavior

### Workshop-Specific Security
- All resources are created in isolated VPC
- Security groups restrict access to necessary ports only
- IAM roles follow least privilege principle
- Container images use non-root users where possible

## 🧹 Cleanup Instructions

**⚠️ Critical**: Complete these steps to avoid ongoing charges:

```bash
# 1. Stop and delete ECS services
aws ecs update-service --cluster workshop-cluster --service workshop-service --desired-count 0
aws ecs delete-service --cluster workshop-cluster --service workshop-service

# 2. Delete ECS cluster
aws ecs delete-cluster --cluster workshop-cluster

# 3. Delete Application Load Balancer
aws elbv2 delete-load-balancer --load-balancer-arn <your-alb-arn>

# 4. Delete ECR repositories
aws ecr delete-repository --repository-name workshop-app --force

# 5. Delete CloudFormation stacks (if used)
aws cloudformation delete-stack --stack-name ecs-workshop-infrastructure

# 6. Verify cleanup
aws ecs list-clusters
aws elbv2 describe-load-balancers
aws ecr describe-repositories
```

## 🔧 Troubleshooting

### Common Issues and Solutions

**Issue**: ECS tasks failing to start
```bash
# Check task definition and logs
aws ecs describe-tasks --cluster <cluster-name> --tasks <task-arn>
aws logs get-log-events --log-group-name /ecs/workshop-app
```

**Issue**: Load balancer health checks failing
```bash
# Verify target group health
aws elbv2 describe-target-health --target-group-arn <target-group-arn>
# Check security group rules
aws ec2 describe-security-groups --group-ids <security-group-id>
```

**Issue**: Container image pull failures
```bash
# Check ECR permissions and image existence
aws ecr describe-repositories
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
```

### Getting Help
- 📖 [Amazon ECS Documentation](https://docs.aws.amazon.com/ecs/)
- 💬 [AWS Containers Roadmap](https://github.com/aws/containers-roadmap)
- 🎓 [AWS Container Training](https://aws.amazon.com/training/learn-about/containers/)
- 🏆 [ECS Best Practices Guide](https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/)

## 📈 Next Steps

After completing this workshop, consider exploring:

### Advanced Topics
- **AWS Fargate**: Serverless container deployment
- **Amazon EKS**: Kubernetes on AWS
- **AWS App Runner**: Fully managed container applications
- **AWS Copilot**: Application-first container deployment

### Integration Patterns
- **CI/CD Pipelines**: AWS CodePipeline with ECS
- **Microservices**: Service mesh with AWS App Mesh
- **Observability**: AWS X-Ray distributed tracing
- **GitOps**: Infrastructure and application deployment

### Certification Paths
- AWS Certified Solutions Architect
- AWS Certified DevOps Engineer
- AWS Certified Security Specialty

## 📞 Support

### Workshop Support
- **Repository Issues**: [Create an issue](https://github.com/vanhoangkha/workshop-studio/issues)
- **Workshop Questions**: Contact maintainers via email
- **Feedback**: Use the feedback form in the workshop conclusion

### AWS Support Resources
- **Documentation**: [Amazon ECS User Guide](https://docs.aws.amazon.com/ecs/)
- **Forums**: [AWS Container Forums](https://forums.aws.amazon.com/forum.jspa?forumID=187)
- **Support**: [AWS Support Center](https://console.aws.amazon.com/support/)
- **Training**: [AWS Container Training Courses](https://aws.amazon.com/training/learn-about/containers/)

## 🤝 Contributing

We welcome contributions to improve this workshop:

### How to Contribute
1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/enhancement`
3. **Test** your changes thoroughly in a clean AWS environment
4. **Document** any new procedures or requirements
5. **Submit** a pull request with detailed description

### Contribution Guidelines
- Test all commands and procedures on multiple platforms
- Update cost estimates if adding new resources
- Maintain consistent formatting and style
- Include troubleshooting information for new features
- Ensure security best practices are followed

## 📄 License

This workshop is licensed under the MIT License. See [LICENSE](../LICENSE) file for details.

## 🙏 Acknowledgments

- **Amazon ECS Team** for excellent service and documentation
- **AWS Container Specialists** for architectural guidance
- **Docker Community** for container best practices
- **Workshop Contributors** for testing and feedback
- **AWS Solutions Architects** for real-world use cases

---

**🚀 Ready to master containerized applications on AWS? Let's dive into Amazon ECS!**

📝 *Last updated: June 16, 2024*
📧 *Questions? Contact: khavan.work@gmail.com*
🐳 *Happy containerizing!*
