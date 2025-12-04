# Security Policy

## Reporting Security Vulnerabilities

We take the security of this project seriously. If you discover a security vulnerability, please follow the responsible disclosure process outlined below.

### For AWS Employees

1. **DO NOT** open a public GitHub issue
2. Report the vulnerability through internal security channels
3. Contact the AWS Security team directly via internal communication tools
4. Use the internal vulnerability reporting system
5. Follow the internal security incident response procedures

### For External Contributors

1. **DO NOT** open a public GitHub issue
2. Email AWS Security at: **aws-security@amazon.com**
3. Include the following information:
   - Detailed description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact and severity assessment
   - Affected versions or components
   - Suggested remediation (if available)
   - Your contact information for follow-up

### What to Expect

- **Acknowledgment:** Within 48 hours of submission
- **Initial Assessment:** Within 5 business days
- **Status Updates:** Regular updates on remediation progress
- **Resolution:** Security patches released as soon as possible
- **Credit:** Public acknowledgment (if desired) after issue resolution

## Security Best Practices

### Code Scanning Requirements

All code must pass the following security scans before publication:

#### For CDK Projects

```bash
# Install cdk-nag
npm install --save-dev cdk-nag

# Add to your CDK application
import { AwsSolutionsChecks } from 'cdk-nag';
import { Aspects } from 'aws-cdk-lib';

// Apply security checks
Aspects.of(app).add(new AwsSolutionsChecks({ verbose: true }));

# Run synthesis to check for violations
cdk synth
```

**Common CDK Security Checks:**
- IAM policies follow least privilege
- S3 buckets have encryption enabled
- Security groups don't allow unrestricted access
- Resources have appropriate logging enabled
- Secrets are not hardcoded

#### For CloudFormation Templates

```bash
# Install cfn-nag
gem install cfn-nag

# Install cfn-lint
pip install cfn-lint

# Run cfn-nag scan
cfn_nag_scan --input-path templates/

# Run cfn-lint
cfn-lint templates/*.yaml --ignore-checks W
```

**CloudFormation Security Checks:**
- No hardcoded credentials
- Proper encryption configuration
- Secure default settings
- Appropriate resource policies
- Logging and monitoring enabled

#### Additional Required Tools

**Amazon Security Hub (ASH):**
```bash
# Project-wide security scanning
ash scan --path .

# Generate security report
ash report --format json --output security-report.json
```

**Prolinter:**
```bash
# Comprehensive security and compliance scanning
prolinter scan --directory .

# Check specific compliance standards
prolinter scan --standard aws-foundational-security
```

**CodeDefender (Pre-commit):**
```bash
# Install pre-commit hooks
pip install pre-commit

# Setup CodeDefender
pre-commit install

# Run manually
pre-commit run --all-files
```

**Git Secrets:**
```bash
# Install git-secrets
brew install git-secrets  # macOS
# or
apt-get install git-secrets  # Linux

# Setup for repository
git secrets --install
git secrets --register-aws

# Scan repository
git secrets --scan
```

### IAM Policy Guidelines

#### Principle of Least Privilege

Always grant the minimum permissions necessary:

**Good Example:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::workshop-bucket/*"
    }
  ]
}
```

**Bad Example:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
```

#### IAM Policy Best Practices

1. **Use Specific Actions:**
   - Avoid wildcards in actions (`s3:*`)
   - List only required actions
   - Use condition keys to further restrict

2. **Scope Resources:**
   - Use specific ARNs instead of `*`
   - Implement resource-level permissions
   - Use tags for dynamic resource selection

3. **Implement Conditions:**
   ```json
   {
     "Condition": {
       "StringEquals": {
         "aws:RequestedRegion": ["us-east-1", "us-west-2"]
       },
       "IpAddress": {
         "aws:SourceIp": "203.0.113.0/24"
       }
     }
   }
   ```

4. **Enable MFA:**
   ```json
   {
     "Condition": {
       "Bool": {
         "aws:MultiFactorAuthPresent": "true"
       }
     }
   }
   ```

5. **Regular Reviews:**
   - Audit policies quarterly
   - Remove unused permissions
   - Update based on actual usage patterns

### Secrets Management

#### Never Commit Secrets

**Prohibited:**
- API keys
- Access keys and secret keys
- Database passwords
- Private keys
- OAuth tokens
- Session tokens
- Encryption keys

#### Use AWS Secrets Manager

```python
# Good example - Using Secrets Manager
import boto3
import json

def get_database_credentials():
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId='prod/database/credentials')
    return json.loads(response['SecretString'])

credentials = get_database_credentials()
```

#### Use AWS Systems Manager Parameter Store

```bash
# Store parameter
aws ssm put-parameter \
    --name "/workshop/database/password" \
    --value "MySecurePassword" \
    --type "SecureString" \
    --key-id "alias/aws/ssm"

# Retrieve parameter
aws ssm get-parameter \
    --name "/workshop/database/password" \
    --with-decryption
```

#### Environment Variables (Local Development Only)

```bash
# .env file (add to .gitignore)
AWS_ACCESS_KEY_ID=your_key_here
AWS_SECRET_ACCESS_KEY=your_secret_here

# Load in application
from dotenv import load_dotenv
load_dotenv()
```

#### Credential Rotation

- Rotate credentials every 90 days
- Use AWS Secrets Manager automatic rotation
- Implement zero-downtime rotation strategies
- Monitor rotation failures

### Infrastructure Security

#### Network Security

**VPC Configuration:**
```yaml
# Use private subnets for resources
PrivateSubnet:
  Type: AWS::EC2::Subnet
  Properties:
    VpcId: !Ref VPC
    CidrBlock: 10.0.1.0/24
    MapPublicIpOnLaunch: false

# Use VPC endpoints
S3Endpoint:
  Type: AWS::EC2::VPCEndpoint
  Properties:
    VpcId: !Ref VPC
    ServiceName: !Sub 'com.amazonaws.${AWS::Region}.s3'
    RouteTableIds:
      - !Ref PrivateRouteTable
```

**Security Groups:**
```yaml
# Restrictive security group
WebServerSecurityGroup:
  Type: AWS::EC2::SecurityGroup
  Properties:
    GroupDescription: Web server security group
    VpcId: !Ref VPC
    SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        SourceSecurityGroupId: !Ref LoadBalancerSecurityGroup
    SecurityGroupEgress:
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        DestinationPrefixListId: !Ref S3PrefixList
```

**Network ACLs:**
- Implement defense in depth
- Use both security groups and NACLs
- Follow deny-by-default approach
- Log denied traffic

#### Data Protection

**Encryption at Rest:**
```yaml
# S3 bucket encryption
DataBucket:
  Type: AWS::S3::Bucket
  Properties:
    BucketEncryption:
      ServerSideEncryptionConfiguration:
        - ServerSideEncryptionByDefault:
            SSEAlgorithm: aws:kms
            KMSMasterKeyID: !Ref KMSKey

# EBS volume encryption
Volume:
  Type: AWS::EC2::Volume
  Properties:
    Encrypted: true
    KmsKeyId: !Ref KMSKey

# RDS encryption
Database:
  Type: AWS::RDS::DBInstance
  Properties:
    StorageEncrypted: true
    KmsKeyId: !Ref KMSKey
```

**Encryption in Transit:**
```yaml
# ALB with HTTPS only
LoadBalancer:
  Type: AWS::ElasticLoadBalancingV2::LoadBalancer
  Properties:
    Scheme: internet-facing
    SecurityGroups:
      - !Ref LoadBalancerSecurityGroup

Listener:
  Type: AWS::ElasticLoadBalancingV2::Listener
  Properties:
    LoadBalancerArn: !Ref LoadBalancer
    Protocol: HTTPS
    Port: 443
    Certificates:
      - CertificateArn: !Ref Certificate
    SslPolicy: ELBSecurityPolicy-TLS-1-2-2017-01
```

#### Logging and Monitoring

**CloudTrail:**
```yaml
Trail:
  Type: AWS::CloudTrail::Trail
  Properties:
    IsLogging: true
    IsMultiRegionTrail: true
    IncludeGlobalServiceEvents: true
    EnableLogFileValidation: true
    EventSelectors:
      - ReadWriteType: All
        IncludeManagementEvents: true
```

**VPC Flow Logs:**
```yaml
FlowLog:
  Type: AWS::EC2::FlowLog
  Properties:
    ResourceType: VPC
    ResourceId: !Ref VPC
    TrafficType: ALL
    LogDestinationType: cloud-watch-logs
    LogGroupName: !Ref FlowLogGroup
```

**CloudWatch Alarms:**
```yaml
UnauthorizedAPICallsAlarm:
  Type: AWS::CloudWatch::Alarm
  Properties:
    AlarmDescription: Alert on unauthorized API calls
    MetricName: UnauthorizedAPICalls
    Namespace: CloudTrailMetrics
    Statistic: Sum
    Period: 300
    EvaluationPeriods: 1
    Threshold: 1
    ComparisonOperator: GreaterThanOrEqualToThreshold
```

### Application Security

#### Input Validation

```python
# Good example - Input validation
import re

def validate_email(email):
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if not re.match(pattern, email):
        raise ValueError("Invalid email format")
    return email

def sanitize_input(user_input):
    # Remove potentially dangerous characters
    return re.sub(r'[<>\"\'%;()&+]', '', user_input)
```

#### SQL Injection Prevention

```python
# Good example - Parameterized queries
import psycopg2

def get_user(user_id):
    conn = psycopg2.connect(database="workshop")
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
    return cursor.fetchone()

# Bad example - String concatenation
# cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")  # DON'T DO THIS
```

#### Cross-Site Scripting (XSS) Prevention

```javascript
// Good example - Escape user input
function escapeHtml(unsafe) {
    return unsafe
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}

// Use Content Security Policy
app.use((req, res, next) => {
    res.setHeader(
        'Content-Security-Policy',
        "default-src 'self'; script-src 'self' 'unsafe-inline'"
    );
    next();
});
```

#### Dependency Management

```bash
# Scan for vulnerabilities
npm audit
pip-audit

# Update dependencies
npm update
pip install --upgrade -r requirements.txt

# Use lock files
npm ci  # Use package-lock.json
pip install -r requirements.txt --require-hashes
```

## Compliance

### AWS Foundational Security Best Practices

This project follows AWS Foundational Security Best Practices:

- **IAM:** Least privilege access, MFA enabled
- **Logging:** CloudTrail, VPC Flow Logs, CloudWatch
- **Encryption:** At rest and in transit
- **Network:** Private subnets, security groups, NACLs
- **Monitoring:** CloudWatch alarms, GuardDuty
- **Backup:** Automated backups, disaster recovery

### GDPR and Data Privacy

- No personal data stored without consent
- Data minimization principles applied
- Right to erasure implemented
- Data encryption enforced
- Access logging enabled
- Data retention policies defined

### Compliance Standards

- **PCI DSS:** For payment card data handling
- **HIPAA:** For healthcare data (if applicable)
- **SOC 2:** Security and availability controls
- **ISO 27001:** Information security management

## Supported Versions

| Version | Supported          | Security Updates |
| ------- | ------------------ | ---------------- |
| 1.0.x   | :white_check_mark: | Yes              |
| < 1.0   | :x:                | No               |

## Security Update Process

1. **Vulnerability Reported:** Security team notified
2. **Assessment:** Severity and impact evaluated (24-48 hours)
3. **Patch Development:** Fix developed and tested (varies by severity)
4. **Security Advisory:** Published with CVE (if applicable)
5. **Patch Release:** Security update released
6. **Notification:** Users notified via GitHub Security Advisory
7. **Documentation:** CHANGELOG.md updated

### Severity Levels

- **Critical:** Immediate patch release (within 24 hours)
- **High:** Patch release within 7 days
- **Medium:** Patch release within 30 days
- **Low:** Included in next regular release

## Security Checklist for Contributors

Before submitting code:

- [ ] No secrets or credentials committed
- [ ] Security scans completed and passed
- [ ] IAM policies follow least privilege
- [ ] Encryption enabled for data at rest
- [ ] TLS/HTTPS used for data in transit
- [ ] Input validation implemented
- [ ] Error handling doesn't expose sensitive info
- [ ] Dependencies scanned for vulnerabilities
- [ ] Logging implemented (without sensitive data)
- [ ] Security documentation updated

## Additional Resources

### AWS Security Documentation

- [AWS Security Best Practices](https://aws.amazon.com/security/best-practices/)
- [AWS Well-Architected Framework - Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
- [AWS Security Documentation](https://docs.aws.amazon.com/security/)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

### Security Tools

- [AWS Security Hub](https://aws.amazon.com/security-hub/)
- [Amazon GuardDuty](https://aws.amazon.com/guardduty/)
- [AWS Config](https://aws.amazon.com/config/)
- [AWS CloudTrail](https://aws.amazon.com/cloudtrail/)

### Training Resources

- [AWS Security Fundamentals](https://aws.amazon.com/training/course-descriptions/security-fundamentals/)
- [AWS Security Engineering](https://aws.amazon.com/training/course-descriptions/security-engineering/)
- [AWS Certified Security - Specialty](https://aws.amazon.com/certification/certified-security-specialty/)

## Contact

For security-related questions or concerns:

- **AWS Employees:** Use internal security channels
- **External Contributors:** aws-security@amazon.com
- **General Questions:** Open a GitHub issue (non-security related only)

---

**Last updated:** December 2025

**Security Policy Version:** 1.0.0
