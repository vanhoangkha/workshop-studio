# 🚀 AWS CLI Fundamentals Workshop

Master the AWS Command Line Interface with hands-on exercises covering IAM, S3, EC2, and automation best practices.

## 📋 Workshop Overview

This comprehensive workshop teaches you how to effectively use the AWS Command Line Interface (CLI) to manage AWS resources, automate tasks, and implement best practices for cloud operations.

### 🎯 Learning Objectives

By the end of this workshop, you will be able to:

- ✅ Install and configure AWS CLI on your local machine
- ✅ Understand AWS CLI authentication and security best practices
- ✅ Manage IAM users, groups, and policies using CLI commands
- ✅ Perform S3 operations including bucket management and file transfers
- ✅ Launch and manage EC2 instances through the command line
- ✅ Automate AWS tasks using CLI scripts and best practices
- ✅ Troubleshoot common CLI issues and errors

### 📊 Workshop Details

| **Attribute** | **Details** |
|---------------|-------------|
| **Level** | Beginner to Intermediate |
| **Duration** | 2-3 hours |
| **Cost** | $2-5 USD (estimated) |
| **Language** | English |
| **Region** | us-east-1 (primary) |

### 🛠️ AWS Services Covered

- **AWS CLI** - Command Line Interface fundamentals
- **IAM** - Identity and Access Management
- **S3** - Simple Storage Service
- **EC2** - Elastic Compute Cloud
- **CloudFormation** - Infrastructure as Code basics

## 🏗️ Workshop Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    AWS CLI Workshop                         │
├─────────────────────────────────────────────────────────────┤
│  Module 1: CLI Installation & Configuration                 │
│  ├── AWS CLI v2 Installation                               │
│  ├── Credential Configuration                              │
│  └── Basic Commands & Help System                          │
├─────────────────────────────────────────────────────────────┤
│  Module 2: IAM Management                                   │
│  ├── User and Group Management                             │
│  ├── Policy Creation and Attachment                        │
│  └── Role Management                                        │
├─────────────────────────────────────────────────────────────┤
│  Module 3: S3 Operations                                    │
│  ├── Bucket Creation and Management                         │
│  ├── File Upload/Download Operations                        │
│  └── Advanced S3 Features                                  │
├─────────────────────────────────────────────────────────────┤
│  Module 4: EC2 Management                                   │
│  ├── Instance Launch and Configuration                      │
│  ├── Security Groups and Key Pairs                         │
│  └── Instance Lifecycle Management                         │
├─────────────────────────────────────────────────────────────┤
│  Module 5: Automation & Best Practices                      │
│  ├── CLI Scripting Techniques                              │
│  ├── Error Handling and Logging                            │
│  └── Security Best Practices                               │
└─────────────────────────────────────────────────────────────┘
```

## 📋 Prerequisites

### 🔐 AWS Account Requirements
- [ ] AWS Account with administrative access or appropriate IAM permissions
- [ ] Credit card on file (minimal charges expected: $2-5)
- [ ] Access to create IAM users, S3 buckets, and EC2 instances

### 💻 Local Environment
- [ ] **Operating System**: Windows 10+, macOS 10.14+, or Linux
- [ ] **Terminal/Command Prompt**: Access to command line interface
- [ ] **Text Editor**: VS Code, Sublime Text, or similar
- [ ] **Internet Connection**: Stable broadband connection

### 📚 Knowledge Prerequisites
- [ ] Basic understanding of cloud computing concepts
- [ ] Familiarity with command line/terminal usage
- [ ] Basic knowledge of AWS core services (helpful but not required)
- [ ] Understanding of JSON format (basic level)

### ✅ Pre-Workshop Validation

Run these commands to verify your setup:

```bash
# Check if you have a terminal/command prompt
echo "Terminal is working!"

# Verify internet connectivity
ping -c 3 aws.amazon.com

# Check if you have a text editor (example with VS Code)
code --version
```

## 🚀 Getting Started

### Option 1: Run Locally
```bash
# Clone the repository
git clone https://github.com/vanhoangkha/workshop-studio.git
cd workshop-studio/aws-cli-workshop

# Start a local web server
python3 -m http.server 8080

# Open your browser to http://localhost:8080
```

### Option 2: AWS Workshop Studio
1. Access [AWS Workshop Studio](https://workshops.aws/)
2. Search for "AWS CLI Fundamentals"
3. Follow the guided setup process

## 📚 Workshop Modules

### Module 1: CLI Installation & Configuration (30 minutes)
- Install AWS CLI v2 on your operating system
- Configure credentials using multiple methods
- Understand CLI profiles and configuration files
- Test basic commands and explore help system

### Module 2: IAM Management (45 minutes)
- Create and manage IAM users and groups
- Attach and detach policies
- Work with IAM roles and assume role operations
- Implement least privilege access principles

### Module 3: S3 Operations (45 minutes)
- Create and configure S3 buckets
- Upload, download, and sync files
- Manage bucket policies and permissions
- Explore advanced S3 features via CLI

### Module 4: EC2 Management (45 minutes)
- Launch EC2 instances with custom configurations
- Manage security groups and key pairs
- Monitor instance status and performance
- Terminate and clean up resources

### Module 5: Automation & Best Practices (30 minutes)
- Write effective CLI scripts
- Implement error handling and logging
- Apply security best practices
- Explore advanced CLI features and tips

## 💰 Cost Breakdown

| **Service** | **Usage** | **Estimated Cost** |
|-------------|-----------|-------------------|
| **EC2** | t3.micro instance (2-3 hours) | $0.50 - $1.00 |
| **S3** | Storage and requests | $0.10 - $0.50 |
| **Data Transfer** | Minimal | $0.05 - $0.25 |
| **Other Services** | IAM, CloudFormation | Free |
| **Total** | | **$2.00 - $5.00** |

> **💡 Cost Optimization Tips:**
> - Use AWS Free Tier eligible resources when possible
> - Complete cleanup section to avoid ongoing charges
> - Monitor usage through AWS Billing Dashboard

## 🧹 Cleanup Instructions

**⚠️ Important**: Complete these steps to avoid ongoing charges:

```bash
# 1. Terminate EC2 instances
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0

# 2. Delete S3 buckets and contents
aws s3 rm s3://your-workshop-bucket --recursive
aws s3 rb s3://your-workshop-bucket

# 3. Delete IAM resources (if created)
aws iam delete-user --user-name workshop-user

# 4. Verify cleanup
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name]'
aws s3 ls | grep workshop
```

## 🔧 Troubleshooting

### Common Issues and Solutions

**Issue**: AWS CLI not found after installation
```bash
# Solution: Add AWS CLI to PATH or reinstall
export PATH=$PATH:/usr/local/bin/aws
```

**Issue**: Access denied errors
```bash
# Solution: Check IAM permissions and credentials
aws sts get-caller-identity
aws configure list
```

**Issue**: Region-related errors
```bash
# Solution: Verify and set correct region
aws configure set region us-east-1
```

### Getting Help
- 📖 [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)
- 💬 [AWS CLI GitHub Issues](https://github.com/aws/aws-cli/issues)
- 🎓 [AWS Training and Certification](https://aws.amazon.com/training/)

## 📞 Support

### Workshop Support
- **Issues**: Create an issue in this repository
- **Questions**: Contact workshop maintainers
- **Feedback**: Use the feedback form in the workshop

### AWS Support
- **Documentation**: [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/)
- **Forums**: [AWS Developer Forums](https://forums.aws.amazon.com/)
- **Support**: [AWS Support Center](https://console.aws.amazon.com/support/)

## 🤝 Contributing

We welcome contributions to improve this workshop:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/improvement`
3. Make your changes and test thoroughly
4. Submit a pull request with detailed description

### Contribution Guidelines
- Follow existing code and documentation style
- Test all commands and procedures
- Update documentation for any changes
- Ensure cross-platform compatibility

## 📄 License

This workshop is licensed under the MIT License. See [LICENSE](../LICENSE) file for details.

## 🙏 Acknowledgments

- AWS CLI team for excellent documentation and tools
- AWS Workshop Studio team for the platform
- Community contributors and testers
- AWS Solutions Architects for best practices guidance

---

**🌟 Ready to master the AWS CLI? Let's get started!**

📝 *Last updated: June 16, 2024*
📧 *Questions? Contact: khavan.work@gmail.com*
