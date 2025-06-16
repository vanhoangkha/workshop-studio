# AWS Workshop Studio - Guideline Tạo Workshop

## Tổng quan
AWS Workshop Studio là nền tảng để tạo và chia sẻ các workshop tương tác về AWS. Guideline này sẽ hướng dẫn bạn tạo workshop chất lượng cao.

## 1. Cấu trúc thư mục chuẩn

```
workshop-name/
├── README.md                 # Mô tả tổng quan workshop
├── workshop-config.json      # Cấu hình workshop
├── content/                  # Nội dung workshop
│   ├── index.md             # Trang chủ
│   ├── introduction/        # Giới thiệu
│   │   └── index.md
│   ├── prerequisites/       # Yêu cầu trước khi bắt đầu
│   │   └── index.md
│   ├── modules/            # Các module chính
│   │   ├── module-1/
│   │   │   ├── index.md
│   │   │   └── assets/     # Hình ảnh, code samples
│   │   ├── module-2/
│   │   └── module-3/
│   ├── cleanup/            # Dọn dẹp tài nguyên
│   │   └── index.md
│   └── conclusion/         # Kết luận
│       └── index.md
├── static/                 # Tài nguyên tĩnh
│   ├── images/
│   └── code/
└── templates/             # CloudFormation/CDK templates
    ├── infrastructure.yaml
    └── application.yaml
```

## 2. File cấu hình workshop-config.json

```json
{
  "title": "Developing on Amazon ECS",
  "description": "Learn how to develop and deploy containerized applications on Amazon ECS",
  "level": "intermediate",
  "duration": "2-3 hours",
  "services": ["ECS", "ECR", "VPC", "ALB", "CloudFormation"],
  "tags": ["containers", "microservices", "devops"],
  "authors": [
    {
      "name": "Your Name",
      "email": "your.email@example.com"
    }
  ],
  "version": "1.0.0",
  "language": "en",
  "region": "us-east-1"
}
```

## 3. Cấu trúc nội dung từng trang

### 3.1 Trang chủ (content/index.md)

```markdown
# Workshop Title

## Overview
Brief description of what participants will learn and build.

## Learning Objectives
- Objective 1
- Objective 2
- Objective 3

## Prerequisites
- AWS Account with appropriate permissions
- Basic knowledge of containers
- Familiarity with AWS CLI

## Architecture
![Architecture Diagram](../static/images/architecture.png)

## Estimated Duration
2-3 hours

## Cost
Estimated cost: $5-10 USD
```

### 3.2 Giới thiệu (content/introduction/index.md)

```markdown
# Introduction

## What is Amazon ECS?
Amazon Elastic Container Service (ECS) is a fully managed container orchestration service...

## Key Concepts
- **Task Definition**: Blueprint for your application
- **Service**: Ensures desired number of tasks are running
- **Cluster**: Logical grouping of compute resources

## Workshop Scenario
In this workshop, you will build a containerized web application...
```

### 3.3 Prerequisites (content/prerequisites/index.md)

```markdown
# Prerequisites

## AWS Account Setup
1. Ensure you have an AWS account
2. Create an IAM user with appropriate permissions
3. Configure AWS CLI

## Required Tools
- AWS CLI v2
- Docker Desktop
- Git
- Text editor (VS Code recommended)

## Verification Steps
Run these commands to verify your setup:

```bash
aws --version
docker --version
git --version
```
```

### 3.4 Module chính (content/modules/module-1/index.md)

```markdown
# Module 1: Setting up the Environment

## Objectives
- Create VPC and networking components
- Set up ECS cluster
- Configure security groups

## Step 1: Create VPC
1. Navigate to VPC console
2. Click "Create VPC"
3. Configure the following settings:
   - Name: `workshop-vpc`
   - CIDR: `10.0.0.0/16`

```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=workshop-vpc}]'
```

## Step 2: Create Subnets
Create public and private subnets in different AZs...

## Verification
Verify your setup by running:
```bash
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=workshop-vpc"
```

## Troubleshooting
Common issues and solutions:
- Issue 1: Solution
- Issue 2: Solution

## Next Steps
In the next module, we'll deploy our first container...
```

### 3.5 Cleanup (content/cleanup/index.md)

```markdown
# Cleanup

## Important
To avoid ongoing charges, please delete all resources created in this workshop.

## Automated Cleanup
Use the provided cleanup script:

```bash
./scripts/cleanup.sh
```

## Manual Cleanup Steps
If the script fails, follow these manual steps:

1. Delete ECS Services
2. Delete ECS Cluster
3. Delete Load Balancer
4. Delete VPC and associated resources

## Verification
Ensure all resources are deleted by checking the AWS Console.
```

## 4. Best Practices

### 4.1 Nội dung
- **Rõ ràng và súc tích**: Mỗi bước phải dễ hiểu
- **Có hình ảnh minh họa**: Screenshots và diagrams
- **Code examples**: Cung cấp code hoàn chỉnh
- **Verification steps**: Cách kiểm tra kết quả
- **Troubleshooting**: Xử lý lỗi thường gặp

### 4.2 Cấu trúc
- **Modular design**: Chia thành các module độc lập
- **Progressive complexity**: Từ đơn giản đến phức tạp
- **Consistent formatting**: Sử dụng markdown chuẩn
- **Navigation**: Links giữa các trang

### 4.3 Kỹ thuật
- **Tested instructions**: Test tất cả các bước
- **Resource cleanup**: Luôn có phần cleanup
- **Cost awareness**: Thông báo về chi phí
- **Security best practices**: Không hardcode credentials

## 5. Templates và Scripts

### 5.1 CloudFormation Template (templates/infrastructure.yaml)

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Infrastructure for ECS Workshop'

Parameters:
  VpcCidr:
    Type: String
    Default: '10.0.0.0/16'
    Description: CIDR block for VPC

Resources:
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: !Ref VpcCidr
      EnableDnsHostnames: true
      EnableDnsSupport: true
      Tags:
        - Key: Name
          Value: workshop-vpc

  # Add more resources...

Outputs:
  VpcId:
    Description: VPC ID
    Value: !Ref VPC
    Export:
      Name: !Sub '${AWS::StackName}-VpcId'
```

### 5.2 Cleanup Script (scripts/cleanup.sh)

```bash
#!/bin/bash

echo "Starting cleanup process..."

# Delete ECS resources
aws ecs update-service --cluster workshop-cluster --service workshop-service --desired-count 0
aws ecs delete-service --cluster workshop-cluster --service workshop-service

# Delete CloudFormation stacks
aws cloudformation delete-stack --stack-name workshop-infrastructure

echo "Cleanup completed. Please verify in AWS Console."
```

## 6. Testing và Quality Assurance

### 6.1 Checklist trước khi publish
- [ ] Tất cả các bước đã được test
- [ ] Screenshots được cập nhật
- [ ] Links hoạt động đúng
- [ ] Code examples chạy được
- [ ] Cleanup script hoạt động
- [ ] Chi phí được tính toán chính xác

### 6.2 Review Process
1. **Technical Review**: Kiểm tra tính chính xác kỹ thuật
2. **Content Review**: Kiểm tra ngữ pháp và cấu trúc
3. **User Testing**: Test với người dùng thực tế

## 7. Deployment và Maintenance

### 7.1 Version Control
- Sử dụng Git để quản lý version
- Tag các release versions
- Maintain changelog

### 7.2 Updates
- Cập nhật khi có service changes
- Monitor feedback và cải thiện
- Keep dependencies up to date

## 8. Ví dụ thực tế

Tham khảo cấu trúc của workshop "developing-on-amazon-ecs" trong thư mục này để hiểu rõ hơn về cách áp dụng guideline.

## Kết luận

Việc tạo một AWS Workshop Studio chất lượng đòi hỏi sự chuẩn bị kỹ lưỡng và attention to detail. Hãy luôn đặt mình vào vị trí của người học để tạo ra trải nghiệm tốt nhất.
