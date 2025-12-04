# Contributing Guidelines

Thank you for your interest in contributing to our project. Whether it's a bug report, new feature, correction, or additional documentation, we greatly value feedback and contributions from our community.

Please read through this document before submitting any issues or pull requests to ensure we have all the necessary information to effectively respond to your bug report or contribution.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)
- [Pull Request Process](#pull-request-process)
- [Code Standards](#code-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Security Issues](#security-issues)

## Code of Conduct

This project has adopted the [Amazon Open Source Code of Conduct](CODE_OF_CONDUCT.md). For more information see the Code of Conduct FAQ or contact opensource-codeofconduct@amazon.com with any additional questions or comments.

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- AWS Account with appropriate permissions
- Git installed and configured
- Familiarity with AWS Workshop Studio
- Understanding of AWS best practices
- Development environment set up (see README.md)

### Setting Up Your Development Environment

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/workshop-studio.git
   cd workshop-studio
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/aws-samples/workshop-studio.git
   ```
4. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## How to Contribute

### Types of Contributions

We welcome the following types of contributions:

1. **Bug Fixes** - Corrections to existing code
2. **New Features** - New workshop examples or tools
3. **Documentation** - Improvements to guides and examples
4. **Workshop Content** - New workshop modules or enhancements
5. **Testing** - Additional test coverage or test improvements

### Contribution Workflow

1. **Check existing issues** - Search for existing issues or create a new one
2. **Discuss your changes** - Comment on the issue to discuss your approach
3. **Fork and branch** - Create a feature branch from main
4. **Make your changes** - Follow our coding standards
5. **Test thoroughly** - Ensure all tests pass
6. **Submit a pull request** - Use our PR template
7. **Address feedback** - Respond to review comments

## Reporting Bugs

### Before Submitting a Bug Report

- **Check the documentation** - Ensure it's not a configuration issue
- **Search existing issues** - Your bug may already be reported
- **Test with latest version** - Verify the bug exists in the current version
- **Gather information** - Collect logs, error messages, and environment details

### How to Submit a Bug Report

Use the bug report template and include:

1. **Clear title** - Descriptive summary of the issue
2. **Description** - Detailed explanation of the problem
3. **Steps to reproduce** - Exact steps to recreate the issue
4. **Expected behavior** - What should happen
5. **Actual behavior** - What actually happens
6. **Environment details**:
   - Operating System and version
   - AWS Region
   - Workshop name and version
   - AWS CLI version (if applicable)
7. **Logs and screenshots** - Relevant error messages or visual evidence
8. **Additional context** - Any other relevant information

### Bug Report Example

```markdown
**Title:** Workshop fails to provision ECS cluster in eu-west-1

**Description:**
When running the ECS workshop in eu-west-1, the CloudFormation stack fails during cluster creation.

**Steps to Reproduce:**
1. Navigate to amazon-ecs-workshop/
2. Deploy contentspec.yaml to eu-west-1
3. Wait for stack creation

**Expected Behavior:**
ECS cluster should be created successfully

**Actual Behavior:**
Stack fails with error: "Service ECS is not available in this region"

**Environment:**
- OS: Ubuntu 22.04
- AWS Region: eu-west-1
- Workshop: amazon-ecs-workshop v1.0.0
- AWS CLI: 2.13.0

**Logs:**
[Attach CloudFormation error logs]
```

## Suggesting Enhancements

### Before Submitting an Enhancement

- **Check the roadmap** - Feature may already be planned
- **Search existing issues** - Enhancement may already be suggested
- **Consider scope** - Ensure it aligns with project goals

### How to Submit an Enhancement

Use the feature request template and include:

1. **Clear title** - Concise description of the enhancement
2. **Problem statement** - What problem does this solve?
3. **Proposed solution** - How should it work?
4. **Alternatives considered** - Other approaches you've thought about
5. **Use cases** - Real-world scenarios where this helps
6. **Implementation details** - Technical approach (if applicable)
7. **Breaking changes** - Impact on existing functionality

## Pull Request Process

### Before Submitting a Pull Request

1. **Update your fork**:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run all tests**:
   ```bash
   # Run unit tests
   npm test

   # Run linters
   npm run lint

   # Run security scans
   cfn_nag_scan --input-path templates/
   ```

3. **Update documentation**:
   - Update README.md if needed
   - Add/update inline code comments
   - Update CHANGELOG.md

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: add new workshop example for Lambda"
   ```

### Commit Message Guidelines

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

**Examples:**
```
feat: add Amazon ECS Fargate workshop example
fix: correct IAM policy in Lambda workshop
docs: update installation instructions
refactor: simplify CloudFormation template structure
test: add integration tests for CLI workshop
```

### Pull Request Checklist

Before submitting, ensure:

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests added/updated and passing
- [ ] Security scans completed and passed
- [ ] CHANGELOG.md updated
- [ ] PR template filled out completely

### Pull Request Template

```markdown
## Description
Brief description of changes

## Related Issue
Fixes #(issue number)

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update
- [ ] Workshop content update

## Testing
Describe testing performed:
- [ ] Unit tests
- [ ] Integration tests
- [ ] Manual testing in AWS account

## Security
- [ ] Security scans completed (cfn-nag, cdk-nag)
- [ ] No secrets or credentials included
- [ ] IAM policies follow least privilege

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests pass
- [ ] CHANGELOG.md updated
```

### Review Process

1. **Automated checks** - CI/CD pipeline runs automatically
2. **Maintainer review** - At least two maintainers review
3. **Address feedback** - Make requested changes
4. **Approval** - Maintainers approve PR
5. **Merge** - Maintainer merges to main branch

## Code Standards

### General Guidelines

- Write clear, readable code
- Follow AWS best practices
- Use meaningful variable and function names
- Keep functions small and focused
- Avoid code duplication
- Handle errors gracefully

### Language-Specific Standards

**Python:**
- Follow PEP 8 style guide
- Use type hints
- Maximum line length: 100 characters
- Use docstrings for functions and classes

**JavaScript/TypeScript:**
- Follow Airbnb style guide
- Use ES6+ features
- Use async/await over callbacks
- Add JSDoc comments

**CloudFormation/YAML:**
- Use 2-space indentation
- Add descriptions to all resources
- Use parameters for configurable values
- Include outputs for important resources

**Markdown:**
- Use ATX-style headers (#)
- Maximum line length: 120 characters
- Add blank lines between sections
- Use code blocks with language specification

### Infrastructure as Code Standards

**CloudFormation:**
```yaml
# Good example
Resources:
  MyBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub '${AWS::StackName}-data-bucket'
      BucketEncryption:
        ServerSideEncryptionConfiguration:
          - ServerSideEncryptionByDefault:
              SSEAlgorithm: AES256
      PublicAccessBlockConfiguration:
        BlockPublicAcls: true
        BlockPublicPolicy: true
        IgnorePublicAcls: true
        RestrictPublicBuckets: true
      Tags:
        - Key: Environment
          Value: !Ref EnvironmentName
```

**CDK (TypeScript):**
```typescript
// Good example
const bucket = new s3.Bucket(this, 'DataBucket', {
  encryption: s3.BucketEncryption.S3_MANAGED,
  blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
  removalPolicy: cdk.RemovalPolicy.DESTROY,
  autoDeleteObjects: true,
});

// Add tags
cdk.Tags.of(bucket).add('Environment', environmentName);
```

## Testing Guidelines

### Test Requirements

- **Unit tests** - Minimum 70% code coverage
- **Integration tests** - Test AWS service interactions
- **End-to-end tests** - Test complete workshop flows
- **Security tests** - Run all security scanning tools

### Writing Tests

**Unit Test Example (Jest):**
```javascript
describe('Workshop Configuration', () => {
  test('should load valid workshop config', () => {
    const config = loadWorkshopConfig('workshop-config.json');
    expect(config).toBeDefined();
    expect(config.title).toBeTruthy();
    expect(config.modules).toHaveLength(3);
  });

  test('should validate IAM policy', () => {
    const policy = loadIAMPolicy('policy.json');
    expect(validatePolicy(policy)).toBe(true);
  });
});
```

### Running Tests

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Run specific test file
npm test -- workshop.test.js

# Run in watch mode
npm test -- --watch
```

## Documentation

### Documentation Requirements

All contributions must include appropriate documentation:

1. **Code Comments**
   - Explain complex logic
   - Document function parameters and return values
   - Add TODO comments for future improvements

2. **README Updates**
   - Update if adding new features
   - Include usage examples
   - Update table of contents

3. **Inline Documentation**
   - Add docstrings/JSDoc
   - Document configuration options
   - Explain design decisions

4. **Workshop Content**
   - Clear learning objectives
   - Step-by-step instructions
   - Troubleshooting sections
   - Cost estimates

### Documentation Style

- Use clear, concise language
- Avoid jargon where possible
- Include code examples
- Add screenshots for UI operations
- Provide links to AWS documentation

## Security Issues

### Reporting Security Vulnerabilities

**DO NOT** open a public GitHub issue for security vulnerabilities.

**For AWS Employees:**
- Report through internal security channels
- Contact AWS Security team directly

**For External Contributors:**
- Email: aws-security@amazon.com
- Include detailed vulnerability information
- Allow time for assessment and remediation

### Security Best Practices

When contributing:

- Never commit secrets, credentials, or API keys
- Use AWS Secrets Manager or Parameter Store
- Follow least privilege for IAM policies
- Enable encryption at rest and in transit
- Run security scans before submitting
- Document security considerations

### Required Security Scans

Before submitting a PR:

```bash
# CloudFormation scanning
cfn_nag_scan --input-path templates/

# CDK scanning (add to code)
npm install --save-dev cdk-nag

# Python security
bandit -r .

# JavaScript security
npm audit

# General security scanning
git secrets --scan
```

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

## Questions?

If you have questions about contributing:

1. Check existing documentation
2. Search closed issues
3. Open a new issue with the "question" label
4. Contact maintainers

## Recognition

Contributors will be recognized in:

- CHANGELOG.md for their contributions
- GitHub contributors page
- Project acknowledgments

Thank you for contributing to AWS Workshop Studio!

---

**Last updated:** December 2025
