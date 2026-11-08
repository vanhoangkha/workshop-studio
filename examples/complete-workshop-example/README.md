#  Complete AWS Workshop Studio Example

This is a comprehensive example of a production-ready AWS Workshop Studio implementation, demonstrating best practices for creating modern, interactive workshops.

##  Overview

This example showcases a **Serverless Web Application Workshop** that teaches participants how to build a complete task management application using:

- **AWS Lambda** for serverless compute
- **Amazon DynamoDB** for NoSQL database
- **Amazon API Gateway** for REST APIs
- **Amazon Cognito** for authentication
- **Amazon S3 + CloudFront** for frontend hosting
- **AWS CloudFormation** for infrastructure as code

##  Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Frontend Layer                           │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │   React SPA     │    │   CloudFront    │                │
│  │   (TypeScript)  │◄───┤   Distribution  │                │
│  └─────────────────┘    └─────────────────┘                │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                    API Layer                                │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │   API Gateway   │    │   Lambda        │                │
│  │   (REST API)    │◄───┤   Functions     │                │
│  └─────────────────┘    └─────────────────┘                │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                    Data Layer                               │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │   DynamoDB      │    │   Cognito       │                │
│  │   (NoSQL DB)    │    │   (Auth)        │                │
│  └─────────────────┘    └─────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

## Project Structure

```
complete-workshop-example/
├── workshop-config.json              # Workshop Studio configuration
├── content/                          # Workshop content
│   ├── index.md                     # Homepage
│   ├── prerequisites/               # Setup requirements
│   ├── modules/                     # Learning modules
│   │   ├── module1/                # Backend development
│   │   ├── module2/                # API Gateway setup
│   │   ├── module3/                # Frontend deployment
│   │   └── module4/                # Monitoring setup
│   ├── cleanup/                     # Resource cleanup
│   └── conclusion/                  # Next steps
├── templates/                        # CloudFormation templates
│   ├── main-infrastructure.yaml     # Complete infrastructure
│   ├── networking.yaml              # VPC and networking
│   ├── storage.yaml                 # DynamoDB and S3
│   ├── compute.yaml                 # Lambda functions
│   └── security.yaml                # IAM roles and policies
├── scripts/                          # Automation scripts
│   ├── validate-prerequisites.sh    # Prerequisites validation
│   ├── deploy-workshop.sh           # Complete deployment
│   ├── cleanup-resources.sh         # Resource cleanup
│   └── run-tests.sh                 # Integration testing
├── static/                           # Static assets
│   ├── images/                      # Workshop images
│   ├── diagrams/                    # Architecture diagrams
│   └── downloads/                   # Downloadable files
├── tests/                            # Testing framework
│   ├── unit/                        # Unit tests
│   ├── integration/                 # Integration tests
│   └── e2e/                         # End-to-end tests
└── README.md                         # This file
```

##  Quick Start

### Option 1: Complete Deployment (Recommended)

Deploy the entire workshop infrastructure with one command:

```bash
# Clone the repository
git clone <repository-url>
cd workshop-studio/examples/complete-workshop-example

# Validate prerequisites
./scripts/validate-prerequisites.sh

# Deploy complete infrastructure
./scripts/deploy-workshop.sh
```

### Option 2: Step-by-Step Learning

Follow the workshop modules for hands-on learning:

```bash
# Start with prerequisites
open content/prerequisites/index.md

# Follow modules in order
open content/modules/module1/index.md  # Backend
open content/modules/module2/index.md  # API Gateway
open content/modules/module3/index.md  # Frontend
open content/modules/module4/index.md  # Monitoring
```

##  Prerequisites

### Required Tools
- **AWS CLI v2** - AWS command line interface
- **Node.js 18+** - JavaScript runtime
- **Git** - Version control
- **Text Editor** - VS Code recommended

### AWS Account Requirements
- **Administrative access** or equivalent permissions
- **Service limits** sufficient for workshop resources
- **Supported regions**: us-east-1, us-west-2, eu-west-1, eu-central-1

### Installation Commands
```bash
# AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

# Node.js (using NodeSource)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Configure AWS
aws configure
```

##  Workshop Features

### **Interactive Elements**
- **Real-time cost tracking** throughout the workshop
- **Progress indicators** for each module
- **Automated validation** of participant work
- **Interactive architecture diagrams**

###  **Automation**
- **One-click deployment** of complete infrastructure
- **Automated testing** and validation
- **Resource cleanup** scripts
- **Prerequisites validation**

###  **Monitoring**
- **CloudWatch dashboards** for application metrics
- **Cost monitoring** and alerts
- **Performance tracking** and optimization
- **Error monitoring** and alerting

### **Security**
- **IAM least privilege** principles
- **Encryption at rest** and in transit
- **Security best practices** throughout
- **Compliance considerations**

## Cost Estimation

| Service | Usage | Estimated Cost |
|---------|-------|----------------|
| **Lambda** | 1M invocations | $2.00 |
| **API Gateway** | 1M requests | $1.50 |
| **DynamoDB** | 1M read/write units | $3.00 |
| **S3** | 1GB storage + requests | $1.00 |
| **CloudFront** | 1GB data transfer | $2.00 |
| **Cognito** | 1000 MAU | $1.00 |
| **Data Transfer** | Various | $2.00 |
| **Total** | 4-hour workshop | **~$12.50** |

>  **Note**: Costs are estimates and may vary by region and usage patterns.

##  Testing

### Automated Testing Suite
```bash
# Run all tests
./scripts/run-tests.sh

# Run specific test categories
./tests/unit/run-unit-tests.sh
./tests/integration/run-integration-tests.sh
./tests/e2e/run-e2e-tests.sh
```

### Manual Testing
```bash
# Test API endpoints
curl -X POST https://api-url/tasks \
  -H "Content-Type: application/json" \
  -d '{"userId":"test","title":"Test Task"}'

# Test frontend
open https://cloudfront-url
```

##  Learning Objectives

### **Primary Objectives**
-  Design and implement serverless architectures
-  Configure API Gateway with Lambda integration
-  Implement DynamoDB data modeling
-  Set up authentication with Cognito
-  Deploy static websites with S3 and CloudFront

### **Secondary Objectives**
-  Implement monitoring and logging
-  Apply security best practices
-  Optimize costs in serverless applications
-  Set up CI/CD pipelines

##  Customization

### Modify Workshop Configuration
```json
{
  "title": "Your Custom Workshop Title",
  "duration": "2-4 hours",
  "cost_estimate": {
    "amount": 15.00,
    "currency": "USD"
  },
  "services": ["Lambda", "DynamoDB", "API Gateway"]
}
```

### Add Custom Modules
```bash
# Create new module
mkdir content/modules/module5
cp content/modules/module1/index.md content/modules/module5/
# Edit content/modules/module5/index.md
```

### Customize Infrastructure
```yaml
# templates/custom-resources.yaml
Resources:
  CustomResource:
    Type: AWS::Lambda::Function
    Properties:
      # Your custom resource configuration
```

## Troubleshooting

### Common Issues

**Issue**: CloudFormation stack creation fails
```bash
# Check stack events
aws cloudformation describe-stack-events --stack-name ServerlessWorkshop

# View detailed error
aws cloudformation describe-stack-resources --stack-name ServerlessWorkshop
```

**Issue**: Lambda function errors
```bash
# View function logs
aws logs tail /aws/lambda/ServerlessWorkshop-CreateTask --follow

# Test function locally
cd src && npm test
```

**Issue**: API Gateway 403 errors
```bash
# Check API Gateway configuration
aws apigateway get-rest-apis

# Verify Lambda permissions
aws lambda get-policy --function-name ServerlessWorkshop-CreateTask
```

### Getting Help

- **GitHub Issues**: [Report bugs and request features](https://github.com/aws-samples/workshop-studio/issues)
- **AWS Documentation**: [Official AWS service documentation](https://docs.aws.amazon.com/)
- **Community Support**: [AWS Developer Forums](https://forums.aws.amazon.com/)

## Cleanup

### Automatic Cleanup
```bash
# Run cleanup script
./scripts/cleanup-resources.sh

# Or delete CloudFormation stack
aws cloudformation delete-stack --stack-name ServerlessWorkshop
```

### Manual Cleanup Verification
```bash
# Verify all resources are deleted
aws cloudformation list-stacks --stack-status-filter DELETE_COMPLETE
aws s3 ls | grep serverlessworkshop
aws lambda list-functions | grep ServerlessWorkshop
```

##  Workshop Analytics

### Metrics Tracked
- **Participation rates** by module
- **Completion times** and success rates
- **Cost per participant** and optimization opportunities
- **Feedback scores** and improvement suggestions

### Viewing Analytics
```bash
# CloudWatch dashboard
aws cloudwatch get-dashboard --dashboard-name ServerlessWorkshop

# Cost analysis
aws ce get-cost-and-usage --time-period Start=2024-01-01,End=2024-01-31
```

## Contributing

### How to Contribute
1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes** and test thoroughly
4. **Commit your changes**: `git commit -m 'Add amazing feature'`
5. **Push to the branch**: `git push origin feature/amazing-feature`
6. **Open a Pull Request**

### Contribution Guidelines
- Follow the existing code style and structure
- Add tests for new functionality
- Update documentation as needed
- Ensure all tests pass before submitting

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **AWS Solutions Architecture Team** for architectural guidance
- **AWS Workshop Studio Team** for platform development
- **Community Contributors** for feedback and improvements
- **AWS Documentation Team** for comprehensive service documentation

---

** Ready to build amazing serverless applications? Start your workshop journey today!**

For questions or support, please open an issue or contact the workshop team.
