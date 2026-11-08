# AWS Workshop Studio - Guideline Tạo Workshop Chi Tiết

##  Tổng quan
AWS Workshop Studio là nền tảng chính thức của AWS để tạo, chia sẻ và chạy các workshop tương tác. Guideline này sẽ hướng dẫn bạn tạo workshop chất lượng cao từ A đến Z.

##  Mục tiêu Workshop
Trước khi bắt đầu, hãy xác định rõ:
- **Đối tượng học viên**: Beginner, Intermediate, Advanced
- **Thời gian dự kiến**: 1-2 giờ, 2-4 giờ, hoặc full-day
- **Kiến thức cần có**: Prerequisites cụ thể
- **Kết quả mong đợi**: Học viên sẽ làm được gì sau workshop

##  Cấu trúc thư mục chuẩn

```
workshop-name/
├── README.md                 # Mô tả tổng quan workshop
├── workshop-config.json      # Cấu hình workshop (bắt buộc)
├── content/                  # Nội dung workshop
│   ├── index.md             # Trang chủ workshop
│   ├── introduction/        # Giới thiệu và overview
│   │   ├── index.md
│   │   └── images/
│   ├── prerequisites/       # Yêu cầu trước khi bắt đầu
│   │   ├── index.md
│   │   ├── aws-account.md
│   │   ├── tools-setup.md
│   │   └── permissions.md
│   ├── modules/            # Các module chính
│   │   ├── module-1/
│   │   │   ├── index.md
│   │   │   ├── step-1.md
│   │   │   ├── step-2.md
│   │   │   └── images/
│   │   ├── module-2/
│   │   └── module-n/
│   ├── cleanup/            # Dọn dẹp resources
│   │   ├── index.md
│   │   └── scripts/
│   └── conclusion/         # Kết luận và next steps
│       ├── index.md
│       ├── resources.md
│       └── feedback.md
├── static/                 # Assets tĩnh
│   ├── images/
│   ├── css/
│   ├── js/
│   └── downloads/
├── templates/              # CloudFormation/CDK templates
│   ├── infrastructure.yaml
│   ├── iam-roles.yaml
│   └── cleanup.yaml
└── scripts/               # Scripts hỗ trợ
    ├── setup.sh
    ├── validate.sh
    └── cleanup.sh
```

##  Cấu hình Workshop (workshop-config.json)

### Template cơ bản:
```json
{
  "title": "Workshop Title - Descriptive and Clear",
  "description": "Detailed description of what participants will learn and build",
  "version": "1.0.0",
  "authors": [
    {
      "name": "Your Name",
      "email": "your.email@example.com",
      "role": "Solutions Architect"
    }
  ],
  "level": "beginner|intermediate|advanced",
  "duration": "2-3 hours",
  "language": "vi|en",
  "tags": ["aws", "serverless", "containers", "beginner"],
  "services": ["lambda", "s3", "dynamodb", "apigateway"],
  "regions": ["us-east-1", "us-west-2", "ap-southeast-1"],
  "architecture": "x86_64|arm64",
  "cost_estimate": {
    "currency": "USD",
    "amount": 5.00,
    "description": "Estimated cost for running this workshop"
  },
  "auto_destroy": true,
  "cleanup_required": true,
  "prerequisites": [
    "Basic AWS knowledge",
    "Familiarity with command line",
    "AWS Account with appropriate permissions"
  ],
  "learning_objectives": [
    "Deploy serverless applications using AWS Lambda",
    "Configure API Gateway for REST APIs",
    "Implement DynamoDB for data storage",
    "Apply security best practices"
  ]
}
```

### Cấu hình nâng cao:
```json
{
  "infrastructure": {
    "cloudformation_template": "templates/infrastructure.yaml",
    "parameters": {
      "InstanceType": "t3.micro",
      "KeyPairName": "workshop-keypair"
    }
  },
  "validation": {
    "pre_workshop": "scripts/validate-prerequisites.sh",
    "post_module": "scripts/validate-module.sh",
    "cleanup": "scripts/validate-cleanup.sh"
  },
  "resources": {
    "max_instances": 5,
    "timeout_minutes": 180,
    "auto_stop": true
  },
  "integrations": {
    "cloud9": true,
    "cloudshell": true,
    "event_engine": true
  }
}
```

##  Viết nội dung Workshop

### 1. Trang chủ (content/index.md)
```markdown
---
title: "Workshop Title"
weight: 10
---

# Welcome to [Workshop Name]

##  Workshop Overview
Brief description of what participants will learn and build.

## Duration
Approximately X hours

##  Learning Objectives
By the end of this workshop, you will be able to:
- [ ] Objective 1
- [ ] Objective 2
- [ ] Objective 3

##  Architecture
![Architecture Diagram](images/architecture.png)

## Cost
This workshop will cost approximately $X.XX to run.

##  Let's Get Started!
Click **Next** to begin with the prerequisites.
```

### 2. Giới thiệu (content/introduction/index.md)
```markdown
---
title: "Introduction"
weight: 20
---

# Introduction to [Technology/Service]

## What is [Technology/Service]?
Detailed explanation with real-world examples.

## Why use [Technology/Service]?
Benefits and use cases.

## Key Concepts
- **Concept 1**: Definition and explanation
- **Concept 2**: Definition and explanation

## Architecture Patterns
Common patterns and best practices.

## Real-world Use Cases
- Use case 1 with example
- Use case 2 with example
```

### 3. Prerequisites (content/prerequisites/index.md)
```markdown
---
title: "Prerequisites"
weight: 30
---

# Prerequisites

##  AWS Account Requirements
- [ ] AWS Account with administrative access
- [ ] Credit card on file (for potential charges)
- [ ] Service limits check

##  Tools and Software
- [ ] AWS CLI v2.x installed and configured
- [ ] Git installed
- [ ] Code editor (VS Code recommended)
- [ ] Docker (if applicable)

##  Knowledge Prerequisites
- [ ] Basic understanding of AWS core services
- [ ] Familiarity with command line interface
- [ ] Basic programming knowledge (if applicable)

##  Validation Steps
Run these commands to verify your setup:

```bash
# Check AWS CLI
aws --version
aws sts get-caller-identity

# Check other tools
git --version
docker --version
```

## Important Notes
- This workshop will create AWS resources that incur costs
- Make sure to complete the cleanup section
- Estimated cost: $X.XX
```

### 4. Module Structure (content/modules/module-1/index.md)
```markdown
---
title: "Module 1: [Module Name]"
weight: 40
---

# Module 1: [Module Name]

##  Module Objectives
By the end of this module, you will:
- [ ] Objective 1
- [ ] Objective 2

##  Overview
Brief overview of what will be covered.

##  Architecture
What we're building in this module.

## Estimated Time
X minutes

##  Let's Begin!
```

### 5. Step-by-step Instructions
```markdown
---
title: "Step 1: [Step Name]"
weight: 41
---

# Step 1: [Step Name]

## What we're doing
Clear explanation of the step's purpose.

## Instructions

### 1. Action Description
Detailed step-by-step instructions.

```bash
# Command to run
aws s3 mb s3://my-workshop-bucket-$(date +%s)
```

**Expected Output:**
```
make_bucket: my-workshop-bucket-1234567890
```

### 2. Verification
How to verify the step was completed successfully.

```bash
# Verification command
aws s3 ls | grep my-workshop-bucket
```

##  Troubleshooting
Common issues and solutions:

**Issue**: Error message example
**Solution**: Step-by-step solution

##  Checkpoint
- [ ] Task 1 completed
- [ ] Task 2 completed
- [ ] Verification successful

## Screenshots
Include relevant screenshots with annotations.
```

##  Best Practices cho Content

### 1. Ngôn ngữ và Tone
- **Rõ ràng và đơn giản**: Tránh thuật ngữ phức tạp
- **Thân thiện**: Sử dụng tone conversational
- **Hướng dẫn cụ thể**: Mỗi bước phải rõ ràng
- **Khuyến khích**: Động viên học viên

### 2. Cấu trúc nội dung
- **Tiêu đề mô tả**: Rõ ràng về nội dung
- **Mục tiêu rõ ràng**: Mỗi module/step có mục tiêu cụ thể
- **Checkpoint**: Điểm kiểm tra sau mỗi bước quan trọng
- **Troubleshooting**: Dự đoán và giải quyết vấn đề

### 3. Code và Commands
```markdown
# Sử dụng code blocks với syntax highlighting
```bash
aws s3 cp file.txt s3://bucket-name/
```

# Giải thích command
```bash
# This command copies a local file to S3
# Replace 'bucket-name' with your actual bucket name
aws s3 cp file.txt s3://your-bucket-name/
```

# Expected output
```
upload: ./file.txt to s3://your-bucket-name/file.txt
```
```

### 4. Hình ảnh và Screenshots
- **Chất lượng cao**: Ít nhất 1080p
- **Annotations**: Highlight các phần quan trọng
- **Consistent**: Cùng browser, theme, size
- **Alt text**: Mô tả cho accessibility

```markdown
![Architecture Diagram](images/architecture.png "Workshop Architecture Overview")
```

##  Templates và CloudFormation

### 1. Infrastructure Template
```yaml
# templates/infrastructure.yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Workshop Infrastructure'

Parameters:
  WorkshopName:
    Type: String
    Default: 'aws-workshop'
    Description: 'Name of the workshop'

Resources:
  WorkshopBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub '${WorkshopName}-${AWS::AccountId}-${AWS::Region}'
      PublicAccessBlockConfiguration:
        BlockPublicAcls: true
        BlockPublicPolicy: true
        IgnorePublicAcls: true
        RestrictPublicBuckets: true

Outputs:
  BucketName:
    Description: 'Workshop S3 Bucket Name'
    Value: !Ref WorkshopBucket
    Export:
      Name: !Sub '${AWS::StackName}-BucketName'
```

### 2. IAM Roles Template
```yaml
# templates/iam-roles.yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Workshop IAM Roles'

Resources:
  WorkshopRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: !Sub 'WorkshopRole-${AWS::Region}'
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: lambda.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
      Policies:
        - PolicyName: WorkshopPolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - s3:GetObject
                  - s3:PutObject
                Resource: !Sub 'arn:aws:s3:::workshop-*/*'
```

##  Testing và Validation

### 1. Pre-workshop Validation Script
```bash
#!/bin/bash
# scripts/validate-prerequisites.sh

echo " Validating prerequisites..."

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

# Check required permissions
echo " AWS CLI configured"

# Check other tools
for tool in git docker; do
    if command -v $tool &> /dev/null; then
        echo " $tool installed"
    else
        echo "⚠  $tool not found (may be optional)"
    fi
done

echo " Prerequisites validation completed!"
```

### 2. Module Validation Script
```bash
#!/bin/bash
# scripts/validate-module.sh

MODULE=$1
echo " Validating Module $MODULE..."

case $MODULE in
    "1")
        # Validate S3 bucket creation
        if aws s3 ls | grep -q "workshop-bucket"; then
            echo " S3 bucket created successfully"
        else
            echo " S3 bucket not found"
            exit 1
        fi
        ;;
    "2")
        # Validate Lambda function
        if aws lambda get-function --function-name workshop-function &> /dev/null; then
            echo " Lambda function created successfully"
        else
            echo " Lambda function not found"
            exit 1
        fi
        ;;
esac

echo " Module $MODULE validation completed!"
```

## Cleanup Section

### Cleanup Instructions (content/cleanup/index.md)
```markdown
---
title: "Cleanup"
weight: 90
---

# Workshop Cleanup

## Important
To avoid ongoing charges, please complete all cleanup steps.

## Resources to Delete

### 1. CloudFormation Stacks
```bash
# Delete main workshop stack
aws cloudformation delete-stack --stack-name workshop-stack

# Wait for deletion to complete
aws cloudformation wait stack-delete-complete --stack-name workshop-stack
```

### 2. S3 Buckets
```bash
# Empty and delete S3 buckets
aws s3 rm s3://your-workshop-bucket --recursive
aws s3 rb s3://your-workshop-bucket
```

### 3. Lambda Functions
```bash
# Delete Lambda functions
aws lambda delete-function --function-name workshop-function
```

##  Verification
Run these commands to verify cleanup:

```bash
# Check CloudFormation stacks
aws cloudformation list-stacks --stack-status-filter DELETE_COMPLETE

# Check S3 buckets
aws s3 ls | grep workshop

# Check Lambda functions
aws lambda list-functions | grep workshop
```

## Cost Verification
- Check AWS Billing Dashboard
- Verify no ongoing charges
- Set up billing alerts for future
```

##  Analytics và Feedback

### 1. Feedback Form
```markdown
---
title: "Feedback"
weight: 100
---

# Workshop Feedback

##  Please provide your feedback

### Overall Rating
- [ ] Excellent (5/5)
- [ ] Good (4/5)
- [ ] Average (3/5)
- [ ] Below Average (2/5)
- [ ] Poor (1/5)

### What did you like most?
[Text area for feedback]

### What could be improved?
[Text area for feedback]

### Would you recommend this workshop?
- [ ] Yes
- [ ] No

### Additional Comments
[Text area for feedback]

## Contact
For questions or support: your.email@example.com
```

##  Publishing và Distribution

### 1. Pre-publication Checklist
- [ ] All content reviewed and tested
- [ ] Screenshots updated and consistent
- [ ] Code examples tested
- [ ] Cost estimates accurate
- [ ] Cleanup procedures verified
- [ ] Feedback mechanisms in place

### 2. Version Control
```bash
# Tag releases
git tag -a v1.0.0 -m "Initial workshop release"
git push origin v1.0.0
```

### 3. Documentation Updates
- Update README.md with workshop details
- Create CHANGELOG.md for version tracking
- Update workshop-config.json version

##  Maintenance và Updates

### 1. Regular Reviews
- **Monthly**: Check for AWS service updates
- **Quarterly**: Review and update content
- **Annually**: Major version updates

### 2. Issue Tracking
- Monitor participant feedback
- Track common issues
- Update troubleshooting sections

### 3. Version Management
```json
{
  "version": "1.2.0",
  "changelog": {
    "1.2.0": "Added new module on security best practices",
    "1.1.0": "Updated for new AWS Console UI",
    "1.0.0": "Initial release"
  }
}
```

##  Resources và Tools

### 1. Useful Tools
- **Markdown Editors**: Typora, Mark Text
- **Screenshot Tools**: Snagit, LightShot
- **Diagram Tools**: Draw.io, Lucidchart
- **Code Formatters**: Prettier, Black

### 2. AWS Resources
- [AWS Workshop Studio Documentation](https://docs.aws.amazon.com/workshop-studio/)
- [AWS Architecture Center](https://aws.amazon.com/architecture/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

### 3. Community
- AWS Community Builders
- AWS User Groups
- Stack Overflow AWS tags

---

##  Kết luận

Tạo một workshop chất lượng cao đòi hỏi:
- **Preparation**: Lên kế hoạch chi tiết
- **Content**: Nội dung rõ ràng, dễ hiểu
- **Testing**: Test kỹ lưỡng trước khi publish
- **Maintenance**: Cập nhật thường xuyên

Hãy luôn đặt mình vào vị trí của học viên và tự hỏi: "Liệu tôi có thể hoàn thành workshop này một cách dễ dàng không?"

**Good luck với workshop của bạn!**
