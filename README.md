# AWS Workshop Studio & Sample Code Publishing Guide

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)

Comprehensive guide and toolkit for creating AWS Workshop Studio workshops and publishing sample code to aws-samples organization.

## Overview

This repository provides complete documentation, examples, and tools for:

- Creating workshops in AWS Workshop Studio
- Publishing sample code to AWS GitHub organizations
- Migrating Hugo-based workshops to Workshop Studio
- Following AWS best practices for workshop development

## Table of Contents

1. [Workshop Creation Process](#workshop-creation-process)
2. [AWS Sample Code Publishing](#aws-sample-code-publishing)
3. [Repository Structure](#repository-structure)
4. [Getting Started](#getting-started)
5. [Examples](#examples)
6. [Documentation](#documentation)
7. [Contributing](#contributing)
8. [License](#license)

## Workshop Creation Process

### Essential AWS Workshop Studio Resources

Before starting, familiarize yourself with these official AWS resources:

- [Creating a Minimal IAM Policy](https://catalog.workshops.aws/docs/en-US/cookbook/creating-aminimal-iam-policy)
- [AWS Account Infrastructure Setup](https://catalog.workshops.aws/docs/en-US/create-aworkshop/authoring-a-workshop/aws-account-infrastructure)
- [Authoring Workshop in Markdown](https://catalog.workshops.aws/docs/en-US/create-aworkshop/authoring-a-workshop/authoring-a-workshop-inmarkdown)
- [Requesting Workshop Review](https://catalog.workshops.aws/docs/en-US/create-aworkshop/reviewing-and-publishing-a-workshop/requesting-aworkshop-review)

### 4-Step Workshop Creation Process

#### Step 1: Create Workshop in AWS Workshop Studio

Access the AWS Workshop Studio platform at https://studio.us-east-1.prod.workshops.aws/

Key Actions:
- Navigate to AWS Workshop Studio console
- Create new workshop project
- Configure basic workshop settings
- Set up workshop metadata and permissions

#### Step 2: Clone the Workshop Project

After creating your workshop, clone the generated project structure:

```bash
git clone <your-workshop-repository-url>
cd <workshop-directory>
```

#### Step 3: Develop Workshop Content

Core Components:
- Markdown files for workshop content and instructions
- contentspec.yaml for infrastructure configuration (CloudFormation template)

#### Step 4: Create Workshop Event

Once development is complete:
- Submit for review through Workshop Studio
- Create workshop events for participants
- Configure event settings (duration, capacity, regions)
- Launch and monitor workshop sessions

## AWS Sample Code Publishing

### Publishing Pathways

#### Simple Release Process (SA/Developer Advocates)

Qualifies for:
- Small amounts of code for documentation, blogs, or workshops
- Code that customers need to adapt/modify for production use
- Demonstrates AWS concepts or workflows

Create ticket: https://t.corp.amazon.com/create/templates/0dc2e94d-5225-4f08-b512-a2cd5b0fdd77

Approved GitHub Organizations:
- aws-samples
- aws-developer-center
- build-on-aws

#### Standard OSS Release (Complex Projects)

Required for:
- Complex applications or frameworks
- Libraries for AWS service interaction
- Production-ready code requiring minimal modification
- Code extending AWS APIs or SDKs

### Publishing Steps

1. **Setup Internal Repository** - Create project in GitLab Internal (https://gitlab.aws.dev/)
2. **Configure Authentication** - Setup SSH and PGP keys
3. **Security Scanning** - Run cdk_nag, cfn_nag, ASH, Prolinter
4. **Code Review** - Minimum two-peer review process
5. **Create aws-samples Repository** - Use OpenSourcerer console
6. **Final Review** - Complete all security and compliance checks
7. **Make Public** - Change repository visibility

## Repository Structure

```
workshop-studio/
├── README.md                    # This file
├── LICENSE                      # Apache 2.0 License
├── CODE_OF_CONDUCT.md          # Community guidelines
├── CONTRIBUTING.md             # Contribution guidelines
├── CHANGELOG.md                # Version history
├── SECURITY.md                 # Security policy
├── .gitignore                  # Git ignore patterns
├── docs/                       # Detailed documentation
│   ├── AWS_WORKSHOP_STUDIO_DEVELOPMENT_GUIDE.md
│   ├── AWS_WORKSHOP_STUDIO_DEVELOPMENT_GUIDE_PART2.md
│   ├── AWS_WORKSHOP_STUDIO_DEVELOPMENT_GUIDE_PART3.md
│   ├── AWS_WORKSHOP_STUDIO_GUIDELINE.md
│   ├── HUGO_TO_WORKSHOP_STUDIO_MIGRATION.md
│   └── MIGRATION_COMPLETE_GUIDE.md
├── examples/                   # Workshop examples
│   ├── complete-workshop-example/
│   ├── testing-framework-example/
│   └── README.md
├── amazon-ecs-workshop/        # ECS workshop example
├── aws-cli-workshop/           # CLI workshop example
└── migrate-hugo-to-workshop-studio.sh  # Migration tool
```

## Getting Started

### Prerequisites

- AWS Account with appropriate permissions
- Git installed locally
- Access to AWS Workshop Studio
- (For internal AWS employees) mwinit and GitLab access

### Quick Start

1. Clone this repository:
```bash
git clone https://github.com/aws-samples/workshop-studio.git
cd workshop-studio
```

2. Review the documentation in the `docs/` directory

3. Explore example workshops in `examples/`, `amazon-ecs-workshop/`, or `aws-cli-workshop/`

4. Follow the guides to create your own workshop

## Examples

This repository includes several complete workshop examples:

### Complete Workshop Example
Full-featured workshop demonstrating best practices with:
- Multi-module structure
- CloudFormation templates
- Automation scripts
- Testing framework

See: `examples/complete-workshop-example/`

### Amazon ECS Workshop
Hands-on workshop for Amazon Elastic Container Service covering:
- Container basics
- ECS cluster setup
- Service deployment
- Best practices

See: `amazon-ecs-workshop/`

### AWS CLI Workshop
Interactive workshop for AWS Command Line Interface:
- CLI installation and configuration
- Common AWS operations
- Automation techniques

See: `aws-cli-workshop/`

## Documentation

Comprehensive documentation is available in the `docs/` directory:

- **AWS Workshop Studio Development Guide** - Complete development workflow
- **AWS Workshop Studio Guideline** - Best practices and standards
- **Hugo to Workshop Studio Migration** - Migration guide for existing workshops
- **Migration Complete Guide** - Step-by-step migration instructions

## Security

### Security Scanning Requirements

**For CDK Projects:**
```bash
npm install cdk-nag
```

**For CloudFormation:**
```bash
gem install cfn-nag
pip install cfn-lint
```

**Additional Tools:**
- Amazon Security Hub (ASH) - Project-wide security scanning
- Prolinter - Comprehensive security reports
- CodeDefender - Pre-commit security scanning

See [SECURITY.md](SECURITY.md) for vulnerability reporting.

## Best Practices

### Workshop Development
- Start with clear learning objectives and measurable outcomes
- Design for multiple skill levels with optional advanced sections
- Include comprehensive cleanup procedures to prevent cost overruns
- Test thoroughly across different AWS accounts and regions
- Provide troubleshooting guides for common issues

### Code Quality
- Follow AWS coding standards and best practices
- Implement comprehensive error handling and validation
- Include detailed documentation and code comments
- Use Infrastructure as Code for reproducible deployments
- Implement automated testing at multiple levels

### Security
- Scan all code with required security tools
- Follow least privilege principles for IAM policies
- Implement secure defaults in all configurations
- Document security considerations and best practices
- Regular security updates and vulnerability patching

## Contributing

We welcome contributions from the community. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

### Contribution Process

1. Fork the repository
2. Create your feature branch
3. Make your changes following our standards
4. Test your changes thoroughly
5. Submit a pull request with clear description

## Support

For issues and questions:
- Review existing documentation in `docs/`
- Check example workshops for reference implementations
- Open an issue for bugs or feature requests
- Refer to official AWS Workshop Studio documentation

## Additional Resources

### Official AWS Documentation
- [AWS Workshop Studio Documentation](https://docs.aws.amazon.com/workshop-studio/)
- [AWS Samples GitHub Organization](https://github.com/aws-samples)

### Tools and Utilities
- [AWS Workshop Studio Console](https://studio.us-east-1.prod.workshops.aws/)
- [GitLab Internal](https://gitlab.aws.dev/)
- [OpenSourcerer Console](https://console.harmony.a2z.com/open-sourcerer/)

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

Based on official AWS documentation for Workshop Studio creation and sample code publishing processes.

---

Last updated: December 2025
