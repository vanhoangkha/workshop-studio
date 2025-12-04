# Module 1: CLI Installation & Configuration

In this module, you'll install the AWS CLI, configure it with your credentials, and learn essential CLI commands and best practices.

## Learning Objectives

By the end of this module, you will:

- Install and verify AWS CLI v2
- Configure AWS credentials and profiles
- Understand CLI output formats
- Use CLI help and documentation
- Implement CLI best practices

## Step 1: Install AWS CLI v2

### Linux/macOS

```bash
# Download installer
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip
unzip awscliv2.zip

# Install
sudo ./aws/install

# Verify installation
aws --version
```

### Windows

Download and run the installer from:
https://awscli.amazonaws.com/AWSCLIV2.msi

Or use PowerShell:
```powershell
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
```

### Verify Installation

```bash
aws --version
# Expected output: aws-cli/2.x.x Python/3.x.x ...
```

## Step 2: Configure AWS Credentials

### Basic Configuration

Run the configuration wizard:

```bash
aws configure
```

You'll be prompted for:
- **AWS Access Key ID**: Your access key
- **AWS Secret Access Key**: Your secret key
- **Default region name**: e.g., `us-east-1`
- **Default output format**: `json`, `yaml`, `text`, or `table`

Example:
```
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

### Verify Configuration

```bash
# Check your identity
aws sts get-caller-identity

# Expected output:
{
    "UserId": "AIDACKCEVSQ6C2EXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/your-username"
}
```

## Step 3: Working with Profiles

Create multiple profiles for different accounts or roles:

```bash
# Configure additional profile
aws configure --profile dev

# Use specific profile
aws s3 ls --profile dev

# Set default profile for session
export AWS_PROFILE=dev
```

View all profiles:

```bash
cat ~/.aws/credentials
cat ~/.aws/config
```

## Step 4: Understanding Output Formats

### JSON (Default)

```bash
aws ec2 describe-regions --output json
```

### Table Format

```bash
aws ec2 describe-regions --output table
```

### Text Format

```bash
aws ec2 describe-regions --output text
```

### YAML Format

```bash
aws ec2 describe-regions --output yaml
```

## Step 5: Using CLI Help

### Command Help

```bash
# Service-level help
aws ec2 help

# Command-level help
aws ec2 describe-instances help

# Quick reference
aws ec2 describe-instances --help
```

### Auto-completion

Enable auto-completion for bash:

```bash
# Add to ~/.bashrc
complete -C '/usr/local/bin/aws_completer' aws

# Reload
source ~/.bashrc
```

## Step 6: Query and Filter Results

### Using --query

```bash
# Get only region names
aws ec2 describe-regions \
    --query 'Regions[*].RegionName' \
    --output text

# Get specific fields
aws ec2 describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType]' \
    --output table
```

### Using --filter

```bash
# Filter running instances
aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=running"

# Filter by tag
aws ec2 describe-instances \
    --filters "Name=tag:Environment,Values=production"
```

## Step 7: CLI Best Practices

### 1. Use IAM Roles (Recommended)

Instead of access keys, use IAM roles when possible:

```bash
# For EC2 instances
aws sts get-caller-identity
# Will use instance profile automatically
```

### 2. Secure Credentials

```bash
# Set restrictive permissions
chmod 600 ~/.aws/credentials
chmod 600 ~/.aws/config

# Never commit credentials to git
echo ".aws/" >> .gitignore
```

### 3. Use Environment Variables

```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_DEFAULT_REGION=us-east-1
```

### 4. Enable CLI Pager

```bash
# Disable pager for scripts
export AWS_PAGER=""

# Or use specific pager
export AWS_PAGER="less -R"
```

### 5. Use Dry Run

Test commands without making changes:

```bash
aws ec2 run-instances \
    --image-id ami-12345678 \
    --instance-type t2.micro \
    --dry-run
```

## Hands-On Exercise

### Exercise 1: List All S3 Buckets

```bash
aws s3 ls
```

### Exercise 2: Get Your Account Information

```bash
aws sts get-caller-identity
aws iam get-user
```

### Exercise 3: List EC2 Regions

```bash
aws ec2 describe-regions --output table
```

### Exercise 4: Create and Use a Profile

```bash
# Create profile
aws configure --profile workshop

# Test profile
aws sts get-caller-identity --profile workshop
```

## Validation

Your CLI setup is complete when:

- ✅ AWS CLI v2 is installed (`aws --version` shows 2.x)
- ✅ Credentials are configured (`aws sts get-caller-identity` succeeds)
- ✅ You can list AWS resources (e.g., `aws s3 ls`)
- ✅ You understand output formats and filtering

## Troubleshooting

**Issue**: Command not found
- **Solution**: Ensure AWS CLI is in your PATH, restart terminal

**Issue**: Invalid credentials
- **Solution**: Verify access keys, check IAM user permissions

**Issue**: Region not set
- **Solution**: Set default region with `aws configure` or use `--region` flag

**Issue**: Permission denied
- **Solution**: Check IAM policies attached to your user/role

## Configuration Files Location

- **Linux/macOS**: `~/.aws/credentials` and `~/.aws/config`
- **Windows**: `%USERPROFILE%\.aws\credentials` and `%USERPROFILE%\.aws\config`

## Next Steps

Now that your AWS CLI is configured, proceed to [Module 2: Working with S3](../module-2/) where you'll learn to manage S3 buckets and objects using the CLI.

## Additional Resources

- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)
- [AWS CLI Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/index.html)
- [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- [AWS CLI Best Practices](https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-best-practices.html)
