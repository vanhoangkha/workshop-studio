# Security Policy

## Reporting Security Vulnerabilities

We take the security of this project seriously. If you discover a security vulnerability, please follow these steps:

### For AWS Employees

1. Do not open a public GitHub issue
2. Report the vulnerability through internal security channels
3. Contact the AWS Security team directly
4. Use the internal vulnerability reporting system

### For External Contributors

1. Do not open a public GitHub issue
2. Email AWS Security at aws-security@amazon.com
3. Include detailed information about the vulnerability:
   - Description of the issue
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if available)

## Security Best Practices

### Code Scanning Requirements

All code must pass the following security scans before publication:

**For CDK Projects:**
```bash
npm install cdk-nag
```

**For CloudFormation Templates:**
```bash
gem install cfn-nag
pip install cfn-lint
```

**Additional Required Tools:**
- Amazon Security Hub (ASH)
- Prolinter
- CodeDefender (pre-commit scanning)

### IAM Policy Guidelines

- Follow the principle of least privilege
- Use minimal IAM policies for workshop resources
- Document all required permissions
- Regularly review and update policies
- Avoid using wildcards in production policies

### Secrets Management

- Never commit secrets, API keys, or credentials to the repository
- Use AWS Secrets Manager or Parameter Store for sensitive data
- Rotate credentials regularly
- Use IAM roles instead of long-term credentials where possible

### Infrastructure Security

- Enable encryption at rest and in transit
- Use VPC endpoints where applicable
- Implement proper network segmentation
- Enable CloudTrail logging
- Use AWS Config for compliance monitoring

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Security Update Process

1. Security issues are reviewed within 48 hours
2. Critical vulnerabilities are patched immediately
3. Security updates are released as patch versions
4. All security updates are documented in CHANGELOG.md

## Compliance

This project follows AWS security best practices and compliance requirements for sample code publication.

## Additional Resources

- [AWS Security Best Practices](https://aws.amazon.com/security/best-practices/)
- [AWS Well-Architected Framework - Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
- [AWS Security Documentation](https://docs.aws.amazon.com/security/)
