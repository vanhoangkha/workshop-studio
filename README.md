# 🚀 AWS Workshop Studio & Sample Code Publishing - Complete Guide

*Comprehensive guide based on official AWS documentation for creating workshops and publishing sample code*

## 📋 Table of Contents

1. [Workshop Creation Process](#-workshop-creation-process)
2. [AWS Sample Code Publishing](#-aws-sample-code-publishing)
3. [Repository Structure](#-repository-structure)
4. [Development Workflow](#-development-workflow)
5. [Security and Compliance](#-security-and-compliance)
6. [Publishing Pathways](#-publishing-pathways)
7. [Best Practices](#-best-practices)

---

## 🎯 Workshop Creation Process

*Based on "How to create a workshop?" by Tran Minh Hai (13/10/2023)*

### 📚 Essential AWS Workshop Studio Resources

Before starting, familiarize yourself with these official AWS resources:

- **[Creating a Minimal IAM Policy](https://catalog.workshops.aws/docs/en-US/cookbook/creating-aminimal-iam-policy)**
- **[AWS Account Infrastructure Setup](https://catalog.workshops.aws/docs/en-US/create-aworkshop/authoring-a-workshop/aws-account-infrastructure)**
- **[Authoring Workshop in Markdown](https://catalog.workshops.aws/docs/en-US/create-aworkshop/authoring-a-workshop/authoring-a-workshop-inmarkdown)**
- **[Requesting Workshop Review](https://catalog.workshops.aws/docs/en-US/create-aworkshop/reviewing-and-publishing-a-workshop/requesting-aworkshop-review)**

### 🔄 4-Step Workshop Creation Process

#### **Step 1: Create Workshop in AWS Workshop Studio**

Access the AWS Workshop Studio platform:
```
🌐 https://studio.us-east-1.prod.workshops.aws/
```

**Key Actions:**
- Navigate to AWS Workshop Studio console
- Create new workshop project
- Configure basic workshop settings
- Set up workshop metadata and permissions

#### **Step 2: Clone the Workshop Project**

After creating your workshop, clone the generated project structure:

```bash
# Clone your workshop repository
git clone <your-workshop-repository-url>
cd <workshop-directory>
```

**Core Components:**
- **📝 Markdown files** - For workshop content and instructions
- **⚙️ contentspec.yaml** - Infrastructure configuration (CloudFormation template)

#### **Step 3: Develop Workshop Content**

**Content Development Structure:**
```
workshop-project/
├── content/                    # Workshop content in Markdown
│   ├── index.md               # Main workshop page
│   ├── introduction/          # Workshop introduction
│   ├── modules/               # Learning modules
│   └── cleanup/               # Resource cleanup
├── contentspec.yaml           # Infrastructure specification
├── static/                    # Static assets (images, files)
└── templates/                 # CloudFormation/CDK templates
```

**Development Workflow:**
1. **Write content in Markdown** - Create engaging, step-by-step instructions
2. **Configure contentspec.yaml** - Define AWS infrastructure requirements
3. **Use CDK for infrastructure** - Generate CloudFormation templates programmatically
4. **Test thoroughly** - Validate all workshop steps and infrastructure

**contentspec.yaml Example:**
```yaml
# Infrastructure specification for Workshop Studio
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Workshop Infrastructure Configuration'

Parameters:
  WorkshopName:
    Type: String
    Default: 'my-aws-workshop'

Resources:
  # Define your AWS resources here
  WorkshopVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      
  WorkshopS3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub '${WorkshopName}-${AWS::AccountId}'
```

#### **Step 4: Create Workshop Event**

Once development is complete:
- **Submit for review** through Workshop Studio
- **Create workshop events** for participants
- **Configure event settings** (duration, capacity, regions)
- **Launch and monitor** workshop sessions

---

## 🔐 AWS Sample Code Publishing

*Complete guide based on "How to publish sample code to the aws sample.docx"*

### 1. 🏢 Access GitLab Internal

**Prerequisites:**
- **mwinit** installed on local machine
- Access to AWS internal systems

**Setup Process:**

#### 1.1 Create GitLab Project
```
🌐 https://gitlab.aws.dev/
```

#### 1.2 Setup Authentication
```bash
# Initialize midway authentication
mwinit -o -k ~/.ssh/id_ecdsa.pub

# Configure SSH for GitLab
echo "Host ssh.gitlab.aws.dev
User git
IdentityFile ~/.ssh/id_ecdsa
CertificateFile ~/.ssh/id_ecdsa-cert.pub
IdentitiesOnly yes
ProxyCommand none
ProxyJump none" >> ~/.ssh/config

# Test SSH connection
ssh ssh.gitlab.aws.dev
```

#### 1.3 Development Workflow
- Clone the project
- Develop your code
- Commit and push changes
- **Note:** May require CodeDefender setup for security scanning

---

### 2. 🛠️ Setup Internal Repository

#### 2.1 Create New Repository in GitLab
Access: **https://gitlab.aws.dev/**

#### 2.2 Setup SSH Connection Requirements

**⚠️ Important Requirements:**
- **Use machine with midway authentication** (NOT an EC2 instance)
- **Setup PGP key** for commit signing
- **Configure CodeDefender** for pre-commit security scanning

#### 2.3 Required Repository Files

**Essential Files to Add:**
```
repository/
├── LICENSE                    # Open source license
├── CODE_OF_CONDUCT.md        # Community guidelines
├── CONTRIBUTING.md           # Contribution guidelines
├── README.md                 # Project documentation
└── .gitignore               # Git ignore patterns
```

#### 2.4 Code Security Scanners

**Required Security Tools:**

**For CDK Projects:**
```bash
# Install and configure cdk_nag
npm install cdk-nag
```

**For CloudFormation:**
```bash
# Install cfn_nag and cfn_lint
gem install cfn-nag
pip install cfn-lint
```

**Additional Security Scanning:**
- **ASH (Amazon Security Hub)** - Project-wide security scanning
- **Prolinter** - Generate comprehensive security reports
- **Save all scanning reports** for compliance

#### 2.5 Two-Peer Code Review Process

**Mandatory Review Process:**
1. **Create pull request** with detailed description
2. **Request two peer reviewers** (minimum requirement)
3. **Address all feedback** before approval
4. **Ensure all security scans pass**

---

### 3. 👨‍💼 SA (Solutions Architect) - Simple Release Process

**For AWS Solutions Architects and Developer Advocates**

#### Qualification Criteria for Simple Releases:
✅ **SAMPLE CODE Qualifies:**
- Small amounts of code for documentation, blogs, or workshops
- Code that customers need to adapt/modify for production use
- Demonstrates AWS concepts or workflows

❌ **NOT SAMPLE CODE:**
- Broad utility or library for AWS services
- Code extending/modifying AWS API/SDK models
- Production-ready applications without modification needs

#### Simple Release Ticket Process:
```
📋 Sample Ticket: https://t.corp.amazon.com/D128468755/overview
🎫 Create Ticket: https://t.corp.amazon.com/create/templates/0dc2e94d-5225-4f08-b512-a2cd5b0fdd77
📚 Documentation: https://w.amazon.com/bin/view/Open_Source/Simple_Releases
```

**Approved GitHub Organizations:**
- `aws-samples`
- `aws-developer-center` 
- `build-on-aws`

---

### 4. 👨‍💼 TAM (Technical Account Manager) - Standard OSS Release

**For Complex Projects Requiring Full OSS Review**

#### Standard OSS Release Process:
```
🎫 Template Ticket: https://t.corp.amazon.com/create/templates/0dc2e94d-5225-4f08-b512-a2cd5b0fdd77
📋 Example Ticket: https://t.corp.amazon.com/D145394290 (developing-on-amazon-ecs-with-cloudformation)
```

**When to Use Standard OSS:**
- Complex applications or frameworks
- Libraries for AWS service interaction
- Production-ready code requiring minimal modification
- Code extending AWS APIs or SDKs

---

### 5. 🐙 Create Private Repository in aws-samples

**GitHub Organization:** https://github.com/aws-samples

#### 5.1 Link GitHub Account to Amazon Profile
```
🔗 https://puzzleglue.open-source.a2z.com/github/auth
```

#### 5.2 Create Team Bindle
```
🏢 https://bindles.amazon.com/
```

#### 5.3 Join aws-samples GitHub Organization

**Self-Invite Process:**
```bash
# Use OpenSourcerer tool
python3 open-sourcerer.pyz github-self-invite
```

**Follow-up Steps:**
1. **Accept invitation** from GitHub email
2. **Follow detailed walkthrough:** https://w.amazon.com/bin/view/Open_Source/GitHub/OpenSourcerer/Walkthroughs/GitHub/SelfInvite/

#### 5.4 Create GitHub Team

Create a dedicated team under aws-samples organization to manage your open-source project.

#### 5.5 Create New Repository

**Repository Creation Portal:**
```
🏗️ https://console.harmony.a2z.com/open-sourcerer/
```

**Required Information:**
- **SIM Ticket ID** (from approved code review)
- **Bindle ID** (from team bindle creation)

#### 5.6 Clone and Populate Repository

**Setup Personal Access Token:**
1. GitHub → Settings → Developer Settings → Personal Access Token
2. Generate token with appropriate permissions

**Clone Repository:**
```bash
# Clone with personal access token
git clone https://GITHUB_USER_ID:PERSONAL_ACCESS_TOKEN@github.com/aws-samples/SAMPLE_PROJECT.git

# Add your source code
cp -r your-project/* SAMPLE_PROJECT/
cd SAMPLE_PROJECT

# Commit and push
git add .
git commit -m "Initial project setup"
git push origin main
```

#### 5.7 Final Review and Public Release

**Pre-Publication Checklist:**
- [ ] **Code review completed** - All functionality tested
- [ ] **README.md comprehensive** - Clear setup and usage instructions
- [ ] **Commit messages clean** - Professional and descriptive
- [ ] **Security scans passed** - All vulnerabilities addressed
- [ ] **Documentation complete** - Architecture diagrams and examples

**Make Repository Public:**
1. Navigate to GitHub Repository Settings
2. Change visibility from Private to Public
3. Confirm public release

**Reference Example:**
```
📚 https://github.com/aws-samples/amazon-eks-cicd-codepipeline-java-microservices/
```

---

### 6. 🔒 Optional Security Content Review

**Additional Security Review (SIM Ticket):**
```
🎫 Create SIM Ticket: https://t.corp.amazon.com/create/templates/0dc2e94d-5225-4f08-b512-a2cd5b0fdd77
📋 Example Review: https://t.corp.amazon.com/D128468755/overview
```

**When to Request:**
- High-security impact code
- Complex infrastructure templates
- Code handling sensitive data
- Enterprise-grade applications

---

### 7. 🌐 Repository Visibility Management

**Final Step: Make Repository Public**

After all reviews and approvals:
1. **Final code review** - Ensure production readiness
2. **Update documentation** - Complete README and guides
3. **Change repository visibility** - Private → Public
4. **Announce release** - Internal and external communication

---

## 🏗️ Repository Structure Standards

Based on both documents, here's the recommended structure:

```
aws-workshop-project/
├── README.md                           # Comprehensive project documentation
├── LICENSE                             # Open source license (required)
├── CODE_OF_CONDUCT.md                  # Community guidelines (required)
├── CONTRIBUTING.md                     # Contribution guidelines (required)
├── .gitignore                          # Git ignore patterns
├── 📁 workshop/                        # Workshop Studio content
│   ├── content/                        # Workshop content in Markdown
│   │   ├── index.md                   # Workshop homepage
│   │   ├── introduction/              # Workshop introduction
│   │   ├── modules/                   # Learning modules
│   │   │   ├── module-1/
│   │   │   ├── module-2/
│   │   │   └── module-n/
│   │   ├── cleanup/                   # Resource cleanup
│   │   └── conclusion/                # Workshop conclusion
│   ├── static/                        # Static assets
│   │   ├── images/
│   │   ├── diagrams/
│   │   └── downloads/
│   └── contentspec.yaml               # Infrastructure specification
├── 📁 templates/                       # CloudFormation/CDK templates
│   ├── infrastructure.yaml
│   ├── security-groups.yaml
│   └── iam-roles.yaml
├── 📁 scripts/                         # Automation scripts
│   ├── setup.sh
│   ├── validate.sh
│   ├── cleanup.sh
│   └── deploy.sh
├── 📁 src/                            # Source code (if applicable)
│   ├── lambda/
│   ├── containers/
│   └── applications/
├── 📁 tests/                          # Testing framework
│   ├── unit/
│   ├── integration/
│   └── security/
└── 📁 docs/                           # Additional documentation
    ├── architecture.md
    ├── security.md
    ├── troubleshooting.md
    └── api-reference.md
```

---

## 🔄 Complete Development Workflow

### Phase 1: Planning and Setup
1. **Define workshop objectives** and target audience
2. **Create Workshop Studio project** at https://studio.us-east-1.prod.workshops.aws/
3. **Setup GitLab internal repository** with proper authentication
4. **Configure security scanning tools** (cdk_nag, cfn_nag, ASH)

### Phase 2: Development
1. **Write workshop content** in Markdown format
2. **Develop infrastructure templates** using CloudFormation/CDK
3. **Create automation scripts** for setup and cleanup
4. **Implement security best practices** throughout

### Phase 3: Testing and Validation
1. **Run security scans** and address all findings
2. **Test workshop end-to-end** in clean AWS account
3. **Validate infrastructure deployment** and cleanup
4. **Conduct peer review** with two reviewers minimum

### Phase 4: Publishing Preparation
1. **Choose publishing pathway** (Simple Release vs Standard OSS)
2. **Create appropriate tickets** (SIM/OSS release tickets)
3. **Setup aws-samples repository** with proper permissions
4. **Complete final documentation** and README

### Phase 5: Publication and Maintenance
1. **Make repository public** after all approvals
2. **Monitor workshop usage** and collect feedback
3. **Maintain and update** content regularly
4. **Address issues** and community contributions

---

## 🛡️ Security and Compliance Requirements

### Code Scanning Requirements

**For CDK Projects:**
```bash
# Install CDK Nag
npm install cdk-nag

# Add to CDK app
import { AwsSolutionsChecks } from 'cdk-nag';
const app = new App();
AwsSolutionsChecks.check(app);
```

**For CloudFormation:**
```bash
# Install cfn-nag
gem install cfn-nag

# Scan templates
cfn_nag_scan --input-path templates/

# Install cfn-lint
pip install cfn-lint

# Validate templates
cfn-lint templates/*.yaml
```

**Amazon Security Hub (ASH):**
- Project-wide security scanning
- Compliance with AWS security standards
- Automated vulnerability detection

### Commit Signing Requirements
```bash
# Setup GPG key for commit signing
gpg --gen-key

# Configure Git to use GPG
git config --global user.signingkey YOUR_GPG_KEY_ID
git config --global commit.gpgsign true
```

### CodeDefender Integration
- Pre-commit security scanning
- Automated vulnerability detection
- Compliance with AWS security policies

---

## 📊 Publishing Pathways Decision Matrix

| **Criteria** | **Simple Release** | **Standard OSS Release** |
|--------------|-------------------|-------------------------|
| **Code Type** | Sample/Demo code | Production libraries |
| **Complexity** | Low to Medium | High |
| **AWS Integration** | Demonstration | Deep integration |
| **Modification Required** | Significant | Minimal |
| **Review Process** | Self-certification | Full OSS review |
| **Timeline** | 1-2 weeks | 4-8 weeks |
| **Eligible Roles** | SA, Developer Advocates | All AWS employees |
| **GitHub Orgs** | aws-samples, build-on-aws | All AWS GitHub orgs |

---

## 🎯 Best Practices Summary

### Workshop Development
- **Start with clear learning objectives** and measurable outcomes
- **Design for multiple skill levels** with optional advanced sections
- **Include comprehensive cleanup procedures** to prevent cost overruns
- **Test thoroughly** across different AWS accounts and regions
- **Provide troubleshooting guides** for common issues

### Code Quality
- **Follow AWS coding standards** and best practices
- **Implement comprehensive error handling** and validation
- **Include detailed documentation** and code comments
- **Use Infrastructure as Code** for reproducible deployments
- **Implement automated testing** at multiple levels

### Security
- **Scan all code** with required security tools
- **Follow least privilege principles** for IAM policies
- **Implement secure defaults** in all configurations
- **Document security considerations** and best practices
- **Regular security updates** and vulnerability patching

### Documentation
- **Write clear, comprehensive README** files
- **Include architecture diagrams** and flow charts
- **Provide step-by-step instructions** with expected outputs
- **Document prerequisites** and setup requirements
- **Include troubleshooting sections** for common issues

---

## 📚 Additional Resources

### Official AWS Documentation
- **[AWS Workshop Studio Documentation](https://docs.aws.amazon.com/workshop-studio/)**
- **[AWS Samples GitHub Organization](https://github.com/aws-samples)**
- **[AWS Open Source Guidelines](https://w.amazon.com/bin/view/How-To-Publish-OpenSource-Code/GitHub-Aws-Samples)**

### Internal AWS Resources
- **[Simple Releases Process](https://w.amazon.com/bin/view/Open_Source/Simple_Releases)**
- **[OpenSourcerer Walkthrough](https://w.amazon.com/bin/view/Open_Source/GitHub/OpenSourcerer/Walkthroughs/GitHub/SelfInvite/)**
- **[Publishing SageMaker Notebooks](https://w.amazon.com/bin/view/How-To-Publish-OpenSource-Code/SageMaker-Notebooks)**

### Tools and Utilities
- **[AWS Workshop Studio Console](https://studio.us-east-1.prod.workshops.aws/)**
- **[GitLab Internal](https://gitlab.aws.dev/)**
- **[OpenSourcerer Console](https://console.harmony.a2z.com/open-sourcerer/)**
- **[Bindles Management](https://bindles.amazon.com/)**

---

## 📞 Support and Contact

### For Workshop Studio Issues
- **AWS Workshop Studio Support** - Through AWS Support Console
- **Workshop Studio Documentation** - Official AWS documentation

### For Sample Code Publishing
- **Open Source Team** - Internal AWS open source support
- **Security Review Team** - For SIM ticket reviews
- **GitHub Administration** - For aws-samples organization issues

### Community Resources
- **AWS Community Forums** - Public community support
- **AWS Samples Issues** - GitHub issues for specific repositories
- **AWS Developer Community** - Broader developer ecosystem

---

*📝 This comprehensive guide combines official AWS documentation for Workshop Studio creation and sample code publishing processes.*

*🔄 Last updated: Based on "How to create a workshop?" (13/10/2023) and "How to publish sample code to the aws sample.docx"*

*⚡ For the most current information, always refer to official AWS documentation and internal AWS resources.*

**© 2024 AWS Workshop Studio & Sample Code Publishing Guide - Complete Implementation Reference**
