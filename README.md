# AWS Workshop Studio & Sample Code Publishing Guide

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)

Comprehensive guide and toolkit for creating AWS Workshop Studio workshops and publishing sample code to aws-samples organization.

## Overview

This repository provides complete documentation, examples, and tools for:

- Creating production-ready workshops in AWS Workshop Studio
- Publishing sample code to AWS GitHub organizations (aws-samples, aws-developer-center, build-on-aws)
- Migrating Hugo-based workshops to Workshop Studio format
- Following AWS best practices for workshop development and security compliance
- Implementing automated testing and CI/CD workflows

## Table of Contents

1. [Workshop Creation Process](#workshop-creation-process)
2. [AWS Sample Code Publishing](#aws-sample-code-publishing)
3. [Repository Structure](#repository-structure)
4. [Getting Started](#getting-started)
5. [Examples](#examples)
6. [Documentation](#documentation)
7. [Security and Compliance](#security-and-compliance)
8. [Best Practices](#best-practices)
9. [Contributing](#contributing)
10. [License](#license)

## Workshop Creation Process

### Essential AWS Workshop Studio Resources

Before starting, familiarize yourself with these official AWS resources:

- [Creating a Minimal IAM Policy](https://catalog.workshops.aws/docs/en-US/cookbook/creating-aminimal-iam-policy) - Learn to create least-privilege IAM policies
- [AWS Account Infrastructure Setup](https://catalog.workshops.aws/docs/en-US/create-aworkshop/authoring-a-workshop/aws-account-infrastructure) - Configure workshop infrastructure
- [Authoring Workshop in Markdown](https://catalog.workshops.aws/docs/en-US/create-aworkshop/authoring-a-workshop/authoring-a-workshop-inmarkdown) - Write workshop content
- [Requesting Workshop Review](https://catalog.workshops.aws/docs/en-US/create-aworkshop/reviewing-and-publishing-a-workshop/requesting-aworkshop-review) - Submit for publication

### 4-Step Workshop Creation Process

#### Step 1: Create Workshop in AWS Workshop Studio

Access the AWS Workshop Studio platform at https://studio.us-east-1.prod.workshops.aws/

**Key Actions:**
- Navigate to AWS Workshop Studio console
- Create new workshop project with descriptive name
- Configure workshop metadata (title, description, duration, difficulty level)
- Set up permissions and access controls
- Define target audience and prerequisites

**Workshop Metadata Requirements:**
- Clear, concise title (max 60 characters)
- Comprehensive description (150-300 words)
- Estimated completion time (realistic timeframe)
- Difficulty level (Beginner, Intermediate, Advanced)
- AWS services covered
- Learning objectives (3-5 measurable outcomes)

#### Step 2: Clone the Workshop Project

After creating your workshop, clone the generated project structure:

```bash
# Clone your workshop repository
git clone <your-workshop-repository-url>
cd <workshop-directory>

# Verify structure
ls -la
```

**Expected Structure:**
```
workshop-name/
├── content/
│   ├── index.md              # Workshop homepage
│   ├── prerequisites/        # Setup instructions
│   └── modules/              # Workshop modules
├── static/                   # Images, assets
├── contentspec.yaml          # Infrastructure definition
└── workshop-config.json      # Workshop configuration
```

#### Step 3: Develop Workshop Content

**Core Components:**

1. **Markdown Content Files**
   - Homepage with overview and objectives
   - Prerequisites and setup instructions
   - Module-based learning content
   - Cleanup and conclusion

2. **Infrastructure as Code (contentspec.yaml)**
   - CloudFormation templates for resource provisioning
   - IAM policies with least privilege
   - Resource tagging for cost tracking
   - Automatic cleanup configurations

3. **Workshop Configuration (workshop-config.json)**
   - Workshop metadata
   - Module ordering
   - Estimated durations
   - AWS region configurations

**Content Development Best Practices:**
- Use clear, concise language
- Include code examples with explanations
- Add screenshots for complex UI operations
- Provide troubleshooting sections
- Include validation steps after each module
- Add cost estimates and cleanup procedures

#### Step 4: Create Workshop Event

Once development is complete:

1. **Submit for Review**
   - Complete internal review checklist
   - Run security scans (cfn-nag, cdk-nag)
   - Test in multiple AWS accounts
   - Submit through Workshop Studio console

2. **Create Workshop Events**
   - Configure event settings (duration, capacity, regions)
   - Set up participant access controls
   - Define cost budgets and alerts
   - Enable analytics and tracking

3. **Launch and Monitor**
   - Monitor participant progress
   - Track resource usage and costs
   - Collect feedback
   - Iterate based on analytics

## AWS Sample Code Publishing

### Publishing Pathways

#### Simple Release Process (SA/Developer Advocates)

**Qualifies for:**
- Small amounts of code for documentation, blogs, or workshops
- Code that customers need to adapt/modify for production use
- Demonstrates AWS concepts or workflows
- Educational or reference implementations

**Process:**
1. Create ticket: https://t.corp.amazon.com/create/templates/0dc2e94d-5225-4f08-b512-a2cd5b0fdd77
2. Complete security scanning (cfn-nag, ASH)
3. Obtain two-peer code review
4. Submit to approved GitHub organization

**Approved GitHub Organizations:**
- **aws-samples** - Sample code and reference implementations
- **aws-developer-center** - Developer-focused content
- **build-on-aws** - Community-driven projects

**Timeline:** 1-2 weeks for approval

#### Standard OSS Release (Complex Projects)

**Required for:**
- Complex applications or frameworks
- Libraries for AWS service interaction
- Production-ready code requiring minimal modification
- Code extending AWS APIs or SDKs
- Projects with external dependencies

**Process:**
1. Create internal GitLab repository
2. Complete comprehensive security review
3. Obtain legal and compliance approval
4. Submit OSS release request
5. Complete OpenSourcerer process

**Timeline:** 4-8 weeks for approval

### Publishing Steps (Detailed)

#### 1. Setup Internal Repository
- Create project in GitLab Internal (https://gitlab.aws.dev/)
- Initialize with README, LICENSE, and .gitignore
- Set up branch protection rules
- Configure CI/CD pipelines

#### 2. Configure Authentication
```bash
# Setup SSH keys
ssh-keygen -t rsa -b 4096 -C "your.email@amazon.com"

# Setup PGP keys for signed commits
gpg --full-generate-key
git config --global user.signingkey <key-id>
git config --global commit.gpgsign true
```

#### 3. Security Scanning

**For CDK Projects:**
```bash
npm install --save-dev cdk-nag
# Add to CDK stack
import { AwsSolutionsChecks } from 'cdk-nag';
Aspects.of(app).add(new AwsSolutionsChecks({ verbose: true }));
```

**For CloudFormation:**
```bash
# Install tools
gem install cfn-nag
pip install cfn-lint

# Run scans
cfn_nag_scan --input-path templates/
cfn-lint templates/*.yaml
```

**Amazon Security Hub (ASH):**
```bash
# Project-wide security scanning
ash scan --path .
```

**Prolinter:**
```bash
# Comprehensive security reports
prolinter scan --directory .
```

#### 4. Code Review
- Minimum two-peer review required
- Review checklist:
  - Code quality and standards
  - Security best practices
  - Documentation completeness
  - Test coverage
  - License compliance

#### 5. Create aws-samples Repository
- Access OpenSourcerer console: https://console.harmony.a2z.com/open-sourcerer/
- Submit repository creation request
- Provide project details and justification
- Wait for approval (1-2 business days)

#### 6. Final Review
- Complete all security and compliance checks
- Verify README completeness
- Ensure all required files present
- Test installation instructions
- Validate examples and documentation

#### 7. Make Public
- Change repository visibility to public
- Announce on internal channels
- Monitor for issues and feedback
- Maintain and update regularly

## Repository Structure

```
workshop-studio/
├── README.md                    # This file - comprehensive guide
├── LICENSE                      # Apache 2.0 License
├── CODE_OF_CONDUCT.md          # Community guidelines
├── CONTRIBUTING.md             # Contribution guidelines
├── CHANGELOG.md                # Version history and release notes
├── SECURITY.md                 # Security policy and reporting
├── .gitignore                  # Git ignore patterns
├── .markdownlint.json          # Markdown linting configuration
│
├── .github/                    # GitHub configuration
│   ├── workflows/              # CI/CD workflows
│   │   ├── link-check.yml      # Automated link validation
│   │   └── markdown-lint.yml   # Markdown quality checks
│   ├── ISSUE_TEMPLATE/         # Issue templates
│   │   ├── bug_report.md       # Bug report template
│   │   └── feature_request.md  # Feature request template
│   └── PULL_REQUEST_TEMPLATE.md # PR template
│
├── docs/                       # Detailed documentation
│   ├── README.md               # Documentation index
│   ├── AWS_WORKSHOP_STUDIO_DEVELOPMENT_GUIDE.md
│   ├── AWS_WORKSHOP_STUDIO_DEVELOPMENT_GUIDE_PART2.md
│   ├── AWS_WORKSHOP_STUDIO_DEVELOPMENT_GUIDE_PART3.md
│   ├── AWS_WORKSHOP_STUDIO_GUIDELINE.md
│   ├── HUGO_TO_WORKSHOP_STUDIO_MIGRATION.md
│   └── MIGRATION_COMPLETE_GUIDE.md
│
├── examples/                   # Workshop examples
│   ├── complete-workshop-example/
│   │   ├── content/            # Workshop content
│   │   ├── templates/          # CloudFormation templates
│   │   ├── scripts/            # Automation scripts
│   │   └── README.md           # Example documentation
│   ├── testing-framework-example/
│   │   ├── tests/              # Test suites
│   │   └── jest.config.js      # Test configuration
│   └── README.md               # Examples overview
│
├── amazon-ecs-workshop/        # ECS workshop example
│   ├── content/                # Workshop modules
│   ├── workshop-config.json    # Configuration
│   └── README.md               # Workshop guide
│
├── aws-cli-workshop/           # CLI workshop example
│   ├── content/                # Workshop modules
│   ├── scripts/                # Helper scripts
│   ├── workshop-config.json    # Configuration
│   └── README.md               # Workshop guide
│
└── migrate-hugo-to-workshop-studio.sh  # Migration automation tool
```

## Getting Started

### Prerequisites

**Required:**
- AWS Account with appropriate permissions (AdministratorAccess or equivalent)
- Git installed locally (version 2.x or higher)
- Access to AWS Workshop Studio (https://studio.us-east-1.prod.workshops.aws/)
- Text editor or IDE (VS Code recommended)

**For Internal AWS Employees:**
- mwinit configured and authenticated
- GitLab access (https://gitlab.aws.dev/)
- OpenSourcerer console access
- Midway authentication

**Recommended:**
- AWS CLI v2 installed and configured
- Node.js 18+ (for CDK projects)
- Python 3.9+ (for automation scripts)
- Docker (for local testing)

### Quick Start

1. **Clone this repository:**
```bash
git clone https://github.com/aws-samples/workshop-studio.git
cd workshop-studio
```

2. **Review the documentation:**
```bash
# Read the main documentation
cat docs/README.md

# Explore development guides
ls -la docs/
```

3. **Explore example workshops:**
```bash
# Complete workshop example
cd examples/complete-workshop-example
cat README.md

# ECS workshop
cd ../../amazon-ecs-workshop
cat README.md

# CLI workshop
cd ../aws-cli-workshop
cat README.md
```

4. **Follow the guides to create your own workshop:**
   - Start with [AWS Workshop Studio Development Guide](docs/AWS_WORKSHOP_STUDIO_DEVELOPMENT_GUIDE.md)
   - Review [AWS Workshop Studio Guideline](docs/AWS_WORKSHOP_STUDIO_GUIDELINE.md)
   - Use examples as templates for your workshop

## Examples

This repository includes several complete workshop examples demonstrating best practices:

### Complete Workshop Example

**Location:** `examples/complete-workshop-example/`

**Features:**
- Multi-module structure with progressive difficulty
- CloudFormation templates for infrastructure
- Automation scripts for setup and cleanup
- Testing framework with Jest
- Comprehensive documentation
- Cost estimation and tracking

**Use Case:** Reference implementation for production workshops

**Technologies:** AWS Lambda, API Gateway, DynamoDB, CloudFormation

### Amazon ECS Workshop

**Location:** `amazon-ecs-workshop/`

**Features:**
- Hands-on workshop for Amazon Elastic Container Service
- Container basics and Docker fundamentals
- ECS cluster setup and configuration
- Service deployment and scaling
- Load balancing and service discovery
- Best practices and troubleshooting

**Use Case:** Learning containerization on AWS

**Technologies:** Amazon ECS, Fargate, ECR, ALB, CloudWatch

**Duration:** 2-3 hours

### AWS CLI Workshop

**Location:** `aws-cli-workshop/`

**Features:**
- Interactive workshop for AWS Command Line Interface
- CLI installation and configuration
- Common AWS operations (EC2, S3, IAM)
- Automation techniques and scripting
- Best practices for CLI usage
- Helper scripts for common tasks

**Use Case:** CLI proficiency for AWS operations

**Technologies:** AWS CLI v2, Bash scripting, IAM

**Duration:** 1-2 hours

## Documentation

Comprehensive documentation is available in the `docs/` directory:

### Core Documentation

- **[AWS Workshop Studio Development Guide](docs/AWS_WORKSHOP_STUDIO_DEVELOPMENT_GUIDE.md)** (554 lines)
  - Complete development workflow from initial setup to publication
  - Workshop design and planning
  - Content development best practices
  - Infrastructure setup and testing

- **[AWS Workshop Studio Development Guide Part 2](docs/AWS_WORKSHOP_STUDIO_DEVELOPMENT_GUIDE_PART2.md)** (795 lines)
  - Advanced topics and techniques
  - Infrastructure as Code patterns
  - Testing strategies and automation
  - Deployment and monitoring

- **[AWS Workshop Studio Development Guide Part 3](docs/AWS_WORKSHOP_STUDIO_DEVELOPMENT_GUIDE_PART3.md)** (613 lines)
  - Best practices and optimization
  - Troubleshooting common issues
  - Performance tuning
  - Maintenance and updates

- **[AWS Workshop Studio Guideline](docs/AWS_WORKSHOP_STUDIO_GUIDELINE.md)** (658 lines)
  - Official guidelines and standards
  - Quality requirements
  - Review process
  - Publication criteria

### Migration Documentation

- **[Hugo to Workshop Studio Migration](docs/HUGO_TO_WORKSHOP_STUDIO_MIGRATION.md)** (374 lines)
  - Migration guide for existing Hugo-based workshops
  - Content conversion strategies
  - Structure mapping
  - Common pitfalls and solutions

- **[Migration Complete Guide](docs/MIGRATION_COMPLETE_GUIDE.md)** (306 lines)
  - Step-by-step migration instructions
  - Automated migration tools
  - Testing and validation
  - Rollback procedures

## Security and Compliance

### Security Scanning Requirements

All code must pass security scanning before publication:

**For CDK Projects:**
```bash
# Install cdk-nag
npm install --save-dev cdk-nag

# Add to your CDK app
import { AwsSolutionsChecks } from 'cdk-nag';
import { Aspects } from 'aws-cdk-lib';

Aspects.of(app).add(new AwsSolutionsChecks({ verbose: true }));
```

**For CloudFormation:**
```bash
# Install tools
gem install cfn-nag
pip install cfn-lint

# Run scans
cfn_nag_scan --input-path templates/
cfn-lint templates/*.yaml --ignore-checks W
```

**Additional Security Tools:**
- **Amazon Security Hub (ASH)** - Project-wide security scanning
- **Prolinter** - Comprehensive security reports and compliance checks
- **CodeDefender** - Pre-commit security scanning and vulnerability detection
- **Bandit** (Python) - Python security linting
- **ESLint** (JavaScript/TypeScript) - JavaScript security patterns

### Compliance Requirements

- All IAM policies must follow least privilege principle
- No hardcoded credentials or secrets
- All data encrypted at rest and in transit
- CloudTrail logging enabled for all resources
- Resource tagging for cost allocation
- Automated cleanup procedures
- GDPR and data privacy compliance

### Security Best Practices

1. **IAM Policies:**
   - Use managed policies where possible
   - Implement resource-level permissions
   - Enable MFA for sensitive operations
   - Regular policy reviews and audits

2. **Secrets Management:**
   - Use AWS Secrets Manager or Parameter Store
   - Rotate credentials regularly
   - Never commit secrets to version control
   - Use IAM roles instead of access keys

3. **Network Security:**
   - Use VPC endpoints for AWS services
   - Implement security groups with minimal access
   - Enable VPC Flow Logs
   - Use private subnets for resources

4. **Data Protection:**
   - Enable encryption at rest (KMS)
   - Use TLS 1.2+ for data in transit
   - Implement backup and recovery procedures
   - Regular security assessments

See [SECURITY.md](SECURITY.md) for detailed security policy and vulnerability reporting procedures.

## Best Practices

### Workshop Development

**Planning:**
- Start with clear learning objectives (3-5 measurable outcomes)
- Define target audience and prerequisites
- Estimate realistic completion time (add 20% buffer)
- Plan for multiple skill levels with optional advanced sections
- Include hands-on exercises in every module

**Content Creation:**
- Use clear, concise language (avoid jargon)
- Include code examples with detailed explanations
- Add screenshots for complex UI operations
- Provide validation steps after each module
- Include troubleshooting sections for common issues

**Infrastructure:**
- Use Infrastructure as Code (CloudFormation/CDK)
- Implement automatic resource cleanup
- Add cost estimates and budget alerts
- Tag all resources for tracking
- Test in multiple AWS regions

**Testing:**
- Test in fresh AWS accounts
- Verify all links and references
- Test cleanup procedures
- Validate IAM permissions
- Check cross-browser compatibility

### Code Quality

**Standards:**
- Follow AWS coding standards and style guides
- Use consistent naming conventions
- Implement comprehensive error handling
- Add detailed code comments
- Write self-documenting code

**Documentation:**
- Include README with clear instructions
- Document all configuration options
- Provide architecture diagrams
- Add inline code comments
- Include troubleshooting guide

**Testing:**
- Write unit tests (minimum 70% coverage)
- Implement integration tests
- Add end-to-end tests
- Automate testing in CI/CD
- Test edge cases and error conditions

**Version Control:**
- Use semantic versioning (MAJOR.MINOR.PATCH)
- Write descriptive commit messages
- Create feature branches
- Use pull requests for all changes
- Tag releases appropriately

### Security

**Code Security:**
- Scan all code with required security tools
- Follow OWASP Top 10 guidelines
- Implement input validation
- Use parameterized queries
- Regular dependency updates

**IAM Security:**
- Follow least privilege principles
- Use IAM roles instead of users
- Implement resource-based policies
- Enable MFA for sensitive operations
- Regular access reviews

**Infrastructure Security:**
- Implement defense in depth
- Use security groups restrictively
- Enable encryption by default
- Implement logging and monitoring
- Regular security assessments

**Operational Security:**
- Document security considerations
- Implement incident response procedures
- Regular security training
- Vulnerability management process
- Security updates and patching

## Contributing

We welcome contributions from the community. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

### Contribution Process

1. **Fork the repository**
   ```bash
   # Fork on GitHub, then clone
   git clone https://github.com/YOUR-USERNAME/workshop-studio.git
   cd workshop-studio
   ```

2. **Create your feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Make your changes following our standards**
   - Follow coding standards
   - Add tests for new functionality
   - Update documentation
   - Run security scans

4. **Test your changes thoroughly**
   ```bash
   # Run tests
   npm test  # or pytest, etc.

   # Run linters
   npm run lint

   # Run security scans
   cfn_nag_scan --input-path templates/
   ```

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add amazing feature"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```

7. **Submit a pull request**
   - Use the PR template
   - Provide clear description
   - Link related issues
   - Request reviews

### Contribution Guidelines

- All contributions must pass CI/CD checks
- Maintain or improve test coverage
- Follow existing code style
- Update documentation for changes
- Add entry to CHANGELOG.md
- Sign commits with GPG key (for AWS employees)

## Support

### Getting Help

**Documentation:**
- Review existing documentation in `docs/`
- Check example workshops for reference implementations
- Read AWS Workshop Studio official documentation

**Issues:**
- Search existing issues before creating new ones
- Use issue templates for bug reports and feature requests
- Provide detailed information and reproduction steps
- Include environment details (OS, AWS region, etc.)

**Community:**
- Open an issue for bugs or feature requests
- Participate in discussions
- Share your workshops and experiences
- Help others in the community

### Reporting Issues

When reporting issues, please include:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Environment details (OS, AWS region, workshop name)
- Relevant logs or error messages
- Screenshots if applicable

## Additional Resources

### Official AWS Documentation
- [AWS Workshop Studio Documentation](https://docs.aws.amazon.com/workshop-studio/) - Official documentation
- [AWS Samples GitHub Organization](https://github.com/aws-samples) - Sample code repository
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) - Best practices
- [AWS Security Best Practices](https://aws.amazon.com/security/best-practices/) - Security guidelines

### Tools and Utilities
- [AWS Workshop Studio Console](https://studio.us-east-1.prod.workshops.aws/) - Workshop management
- [GitLab Internal](https://gitlab.aws.dev/) - Internal code repository (AWS employees)
- [OpenSourcerer Console](https://console.harmony.a2z.com/open-sourcerer/) - OSS release management (AWS employees)
- [AWS CLI](https://aws.amazon.com/cli/) - Command line interface
- [AWS CDK](https://aws.amazon.com/cdk/) - Infrastructure as Code

### Learning Resources
- [AWS Training and Certification](https://aws.amazon.com/training/) - Official training
- [AWS Workshops](https://workshops.aws/) - Hands-on workshops
- [AWS Builders Library](https://aws.amazon.com/builders-library/) - Best practices
- [AWS Architecture Center](https://aws.amazon.com/architecture/) - Reference architectures

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

### Apache License 2.0

```
Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
SPDX-License-Identifier: Apache-2.0
```

You may obtain a copy of the License at: http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Acknowledgments

This project is based on official AWS documentation for Workshop Studio creation and sample code publishing processes. Special thanks to:

- AWS Workshop Studio team for the platform and documentation
- AWS Open Source team for publishing guidelines
- AWS Solutions Architects and Developer Advocates for workshop examples
- Community contributors for feedback and improvements

## Maintainers

This repository is maintained by AWS Solutions Architects and Developer Advocates. For questions or support, please open an issue.

---

**Last updated:** December 2025

**Version:** 1.0.0

**Status:** Production Ready
