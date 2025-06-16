#!/bin/bash

# Migration script from Hugo to AWS Workshop Studio
# Usage: ./migrate-hugo-to-workshop-studio.sh <source-dir> <target-dir>

set -e

HUGO_DIR="$1"
OUTPUT_DIR="$2"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validate inputs
if [ -z "$HUGO_DIR" ] || [ -z "$OUTPUT_DIR" ]; then
    print_error "Usage: $0 <hugo-source-directory> <workshop-studio-output-directory>"
    echo "Example: $0 ./000011-AWSCLI ./000011-AWSCLI-converted"
    exit 1
fi

if [ ! -d "$HUGO_DIR" ]; then
    print_error "Source directory '$HUGO_DIR' does not exist"
    exit 1
fi

print_status "Starting migration from Hugo to AWS Workshop Studio format"
print_status "Source: $HUGO_DIR"
print_status "Target: $OUTPUT_DIR"

# Create Workshop Studio directory structure
print_status "Creating Workshop Studio directory structure..."
mkdir -p "$OUTPUT_DIR"/{content/{introduction,prerequisites,modules/{module-1,module-2,module-3,module-4,module-5},cleanup,conclusion},static/{images,code},templates,scripts}

# Function to convert Hugo front matter and shortcodes
convert_hugo_content() {
    local input_file="$1"
    local output_file="$2"
    
    print_status "Converting: $input_file -> $output_file"
    
    # Create output directory if it doesn't exist
    mkdir -p "$(dirname "$output_file")"
    
    # Convert Hugo content to Workshop Studio format
    sed -e '/^---$/,/^---$/d' \
        -e 's/{{% notice tip %}}/> 💡 **Tip**:/g' \
        -e 's/{{% notice warning %}}/> ⚠️ **Warning**:/g' \
        -e 's/{{% notice info %}}/> ℹ️ **Info**:/g' \
        -e 's/{{% notice note %}}/> 📝 **Note**:/g' \
        -e 's/{{% notice danger %}}/> 🚨 **Danger**:/g' \
        -e 's/{{% \/notice %}}/\n/g' \
        -e 's/{{< highlight \([^>]*\) >}}/```\1/g' \
        -e 's/{{< \/highlight >}}/```/g' \
        -e 's/{{% children[^}]*%}}//g' \
        -e 's/{{% button[^}]*%}}//g' \
        -e 's/chapter: true//g' \
        -e 's/weight: [0-9]*//g' \
        -e 's/\/images\//..\/..\/static\/images\//g' \
        "$input_file" > "$output_file"
}

# Convert content files
print_status "Converting content files..."

# Find and convert all _index.md files
if [ -d "$HUGO_DIR/content" ]; then
    find "$HUGO_DIR/content" -name "_index.md" | while read -r file; do
        # Get relative path from content directory
        rel_path=$(realpath --relative-to="$HUGO_DIR/content" "$file")
        
        # Convert _index.md to index.md and adjust path
        new_rel_path="${rel_path/_index.md/index.md}"
        
        # Handle special cases
        if [[ "$new_rel_path" == "index.md" ]]; then
            # Root _index.md becomes content/index.md
            output_file="$OUTPUT_DIR/content/index.md"
        else
            output_file="$OUTPUT_DIR/content/$new_rel_path"
        fi
        
        convert_hugo_content "$file" "$output_file"
    done
    
    # Convert any regular .md files
    find "$HUGO_DIR/content" -name "*.md" ! -name "_index.md" | while read -r file; do
        rel_path=$(realpath --relative-to="$HUGO_DIR/content" "$file")
        output_file="$OUTPUT_DIR/content/$rel_path"
        convert_hugo_content "$file" "$output_file"
    done
else
    print_warning "No content directory found in Hugo source"
fi

# Copy static files
print_status "Copying static assets..."
if [ -d "$HUGO_DIR/static" ]; then
    cp -r "$HUGO_DIR/static"/* "$OUTPUT_DIR/static/" 2>/dev/null || print_warning "No static files to copy"
    print_success "Static files copied"
else
    print_warning "No static directory found in Hugo source"
fi

# Create workshop-config.json
print_status "Creating workshop-config.json..."
cat > "$OUTPUT_DIR/workshop-config.json" << 'EOF'
{
  "title": "AWS CLI Fundamentals",
  "description": "Master the AWS Command Line Interface with hands-on exercises covering IAM, S3, EC2, and automation best practices",
  "level": "beginner",
  "duration": "2-3 hours",
  "services": ["CLI", "IAM", "S3", "EC2", "CloudFormation"],
  "tags": ["cli", "automation", "scripting", "iam", "s3"],
  "authors": [
    {
      "name": "AWS Workshop Team",
      "email": "workshop-team@amazon.com"
    }
  ],
  "version": "1.0.0",
  "language": "en",
  "region": "us-east-1",
  "estimated_cost": "$2-5 USD",
  "prerequisites": [
    "AWS Account with appropriate permissions",
    "Basic command line knowledge",
    "Text editor"
  ]
}
EOF

# Create README.md
print_status "Creating README.md..."
cat > "$OUTPUT_DIR/README.md" << 'EOF'
# AWS CLI Fundamentals Workshop

This workshop teaches you how to effectively use the AWS Command Line Interface (CLI) to manage AWS resources and automate common tasks.

## Quick Start

1. **Prerequisites**: Ensure you have an AWS account and necessary tools installed
2. **Start the workshop**: Begin with [content/index.md](content/index.md)
3. **Follow the modules**: Complete each module in sequence
4. **Clean up**: Don't forget to clean up resources when finished

## Workshop Structure

```
000011-AWSCLI/
├── README.md                    # This file
├── workshop-config.json         # Workshop metadata
├── content/                     # Workshop content
│   ├── index.md                # Workshop homepage
│   ├── introduction/           # AWS CLI overview
│   ├── prerequisites/          # Setup requirements
│   ├── modules/               # Main workshop modules
│   ├── cleanup/               # Resource cleanup
│   └── conclusion/            # Workshop wrap-up
├── static/                    # Static assets
├── templates/                # CloudFormation templates
└── scripts/                  # Utility scripts
```

## Learning Objectives

- Install and configure AWS CLI
- Understand AWS CLI authentication and permissions
- Execute common AWS operations using CLI commands
- Create automation scripts using AWS CLI
- Follow security best practices

## Duration
2-3 hours

## Cost
Estimated $2-5 USD (with proper cleanup)

## Getting Started

Start with [content/index.md](content/index.md) to begin the workshop.
EOF

# Create sample module structure if content is empty
if [ ! -f "$OUTPUT_DIR/content/index.md" ]; then
    print_status "Creating sample content structure..."
    
    # Create main index.md
    cat > "$OUTPUT_DIR/content/index.md" << 'EOF'
# AWS CLI Fundamentals Workshop

## Overview
Welcome to the AWS CLI Fundamentals workshop! This hands-on workshop will teach you how to effectively use the AWS Command Line Interface (CLI) to manage your AWS resources, automate common tasks, and implement best practices for cloud operations.

## Learning Objectives
By the end of this workshop, you will be able to:
- Install and configure the AWS CLI
- Understand AWS CLI authentication and permissions
- Execute common AWS operations using CLI commands
- Create and manage AWS resources programmatically
- Implement automation scripts using AWS CLI
- Follow security best practices for CLI usage

## Prerequisites
- AWS Account with appropriate permissions
- Basic command line knowledge (Terminal/Command Prompt)
- Text editor (VS Code, nano, or similar)
- Internet connection for downloading tools

## Workshop Modules

1. **[Introduction](introduction/)** - AWS CLI overview and benefits
2. **[Prerequisites](prerequisites/)** - Setting up your environment
3. **[Module 1: CLI Installation & Configuration](modules/module-1/)** - Install and configure AWS CLI
4. **[Module 2: IAM and Security](modules/module-2/)** - Managing users, roles, and permissions
5. **[Module 3: S3 Operations](modules/module-3/)** - Working with S3 buckets and objects
6. **[Module 4: EC2 Management](modules/module-4/)** - Managing EC2 instances
7. **[Module 5: Automation & Scripting](modules/module-5/)** - Creating automation scripts
8. **[Cleanup](cleanup/)** - Removing all created resources

## Estimated Duration
**2-3 hours** (depending on your experience level)

## Estimated Cost
**$2-5 USD** (assuming you complete the workshop within the estimated time and clean up resources)

## Let's Get Started!
Ready to master the AWS CLI? Let's begin with the [Introduction](introduction/) to understand the fundamentals.
EOF

    # Create introduction
    cat > "$OUTPUT_DIR/content/introduction/index.md" << 'EOF'
# Introduction to AWS CLI

## What is AWS CLI?

The AWS Command Line Interface (CLI) is a unified tool to manage your AWS services. With just one tool to download and configure, you can control multiple AWS services from the command line and automate them through scripts.

## Key Benefits

- **Unified Interface**: Single tool for all AWS services
- **Automation**: Script and automate AWS operations
- **Efficiency**: Faster than using the AWS Console for repetitive tasks
- **Integration**: Easy integration with CI/CD pipelines
- **Cross-platform**: Works on Windows, macOS, and Linux

## What You'll Learn

In this workshop, you will:
1. Install and configure AWS CLI
2. Learn essential CLI commands
3. Manage IAM users and permissions
4. Work with S3 storage
5. Control EC2 instances
6. Create automation scripts

## Next Steps

Let's start by setting up your environment in the [Prerequisites](../prerequisites/) section.
EOF

    # Create prerequisites
    cat > "$OUTPUT_DIR/content/prerequisites/index.md" << 'EOF'
# Prerequisites

## AWS Account Requirements

You will need:
- An AWS account with administrative permissions
- Access to create IAM users, roles, and policies
- Ability to create S3 buckets and EC2 instances

## Local Environment Setup

### Required Tools
- **Terminal/Command Prompt**: Command line access
- **Text Editor**: VS Code, nano, vim, or similar
- **Internet Connection**: For downloading AWS CLI and accessing AWS services

### Recommended Setup
- **Operating System**: Windows 10+, macOS 10.14+, or Linux
- **Python**: Version 3.7+ (for AWS CLI v2)
- **Git**: For version control (optional but recommended)

## Verification

Before proceeding, verify you can:
1. Access your AWS account
2. Open a terminal/command prompt
3. Edit text files
4. Access the internet

## Next Steps

Once you've verified your setup, continue to [Module 1: CLI Installation & Configuration](../modules/module-1/).
EOF

    print_success "Sample content structure created"
fi

# Create cleanup script
print_status "Creating cleanup script..."
cat > "$OUTPUT_DIR/scripts/cleanup.sh" << 'EOF'
#!/bin/bash

echo "🧹 Starting AWS CLI Workshop Cleanup..."

# Note: This is a template cleanup script
# Add specific cleanup commands based on resources created in your workshop

echo "⚠️  Please manually verify and delete the following resources:"
echo "   - IAM users created during the workshop"
echo "   - S3 buckets and objects"
echo "   - EC2 instances"
echo "   - Any other resources created"

echo "✅ Cleanup reminder completed"
echo "💡 Always verify in AWS Console that all resources are deleted"
EOF

chmod +x "$OUTPUT_DIR/scripts/cleanup.sh"

# Final validation
print_status "Performing final validation..."

# Check if essential files exist
essential_files=(
    "$OUTPUT_DIR/workshop-config.json"
    "$OUTPUT_DIR/README.md"
    "$OUTPUT_DIR/content/index.md"
)

for file in "${essential_files[@]}"; do
    if [ -f "$file" ]; then
        print_success "✓ $(basename "$file") created"
    else
        print_error "✗ $(basename "$file") missing"
    fi
done

# Summary
print_success "Migration completed successfully!"
echo ""
echo "📁 Workshop Studio structure created at: $OUTPUT_DIR"
echo "📝 Next steps:"
echo "   1. Review and customize content in $OUTPUT_DIR/content/"
echo "   2. Update workshop-config.json with accurate information"
echo "   3. Add any missing static assets to $OUTPUT_DIR/static/"
echo "   4. Test the workshop flow"
echo "   5. Update cleanup procedures in $OUTPUT_DIR/scripts/cleanup.sh"
echo ""
echo "🚀 Your workshop is ready for AWS Workshop Studio!"
EOF
