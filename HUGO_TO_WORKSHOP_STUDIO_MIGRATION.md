# Hướng dẫn chuyển đổi từ Hugo sang AWS Workshop Studio

## Tổng quan
Hướng dẫn này sẽ giúp bạn chuyển đổi workshop từ format Hugo sang AWS Workshop Studio format chuẩn.

## 1. So sánh cấu trúc

### Hugo Structure (Trước)
```
hugo-workshop/
├── config.toml              # Hugo configuration
├── content/                 # Content files
│   ├── _index.md           # Homepage
│   ├── introduction/
│   │   └── _index.md
│   ├── lab1/
│   │   └── _index.md
│   └── cleanup/
│       └── _index.md
├── static/                  # Static assets
│   ├── images/
│   └── css/
├── layouts/                 # Hugo templates
├── themes/                  # Hugo themes
└── data/                   # Data files
```

### AWS Workshop Studio Structure (Sau)
```
workshop-studio/
├── README.md                # Workshop overview
├── workshop-config.json     # Workshop metadata
├── content/                 # Workshop content
│   ├── index.md            # Homepage (không có underscore)
│   ├── introduction/
│   │   └── index.md        # Module content
│   ├── modules/
│   │   ├── module-1/
│   │   │   └── index.md
│   │   └── module-2/
│   │       └── index.md
│   ├── cleanup/
│   │   └── index.md
│   └── conclusion/
│       └── index.md
├── static/                  # Static resources
│   ├── images/
│   └── code/
├── templates/              # CloudFormation/CDK templates
└── scripts/               # Utility scripts
```

## 2. Bước chuyển đổi chi tiết

### Bước 1: Tạo cấu trúc thư mục mới

```bash
# Tạo cấu trúc Workshop Studio
mkdir -p workshop-studio-converted/{content/{introduction,prerequisites,modules/{module-1,module-2,module-3},cleanup,conclusion},static/{images,code},templates,scripts}
```

### Bước 2: Chuyển đổi Hugo config sang workshop-config.json

**Hugo config.toml (ví dụ):**
```toml
baseURL = "https://example.com"
languageCode = "en-us"
title = "AWS CLI Workshop"
theme = "learn"

[params]
  version = "1.0"
  description = "Learn AWS CLI basics"
  author = "AWS Team"
```

**Chuyển thành workshop-config.json:**
```json
{
  "title": "AWS CLI Workshop",
  "description": "Learn AWS CLI basics and best practices",
  "level": "beginner",
  "duration": "2 hours",
  "services": ["CLI", "IAM", "S3", "EC2"],
  "tags": ["cli", "automation", "scripting"],
  "authors": [
    {
      "name": "AWS Team",
      "email": "aws-team@example.com"
    }
  ],
  "version": "1.0.0",
  "language": "en",
  "region": "us-east-1"
}
```

### Bước 3: Chuyển đổi content files

#### Hugo _index.md → Workshop Studio index.md

**Hugo format:**
```markdown
---
title: "AWS CLI Workshop"
chapter: true
weight: 1
---

# AWS CLI Workshop

Welcome to the AWS CLI workshop...

{{% children showhidden="false" %}}
```

**Workshop Studio format:**
```markdown
# AWS CLI Workshop

## Overview
Welcome to the AWS CLI workshop! This hands-on workshop will teach you...

## Learning Objectives
- Master AWS CLI basics
- Understand IAM permissions
- Automate common tasks

## Prerequisites
- AWS Account
- Basic command line knowledge

## Architecture
[Architecture diagram here]

## Workshop Modules
1. [Introduction](introduction/)
2. [Prerequisites](prerequisites/)
3. [Module 1: CLI Setup](modules/module-1/)
4. [Module 2: Basic Commands](modules/module-2/)
5. [Cleanup](cleanup/)

## Estimated Duration
2 hours

## Let's Get Started!
Ready to learn AWS CLI? Start with [Introduction](introduction/).
```

#### Chuyển đổi Hugo shortcodes

**Hugo shortcodes → Markdown standard:**

```markdown
<!-- Hugo -->
{{% notice warning %}}
This is a warning
{{% /notice %}}

<!-- Workshop Studio -->
> ⚠️ **Warning**: This is a warning

<!-- Hugo -->
{{< highlight bash >}}
aws s3 ls
{{< /highlight >}}

<!-- Workshop Studio -->
```bash
aws s3 ls
```

<!-- Hugo -->
{{% children %}}

<!-- Workshop Studio -->
## Next Steps
Continue to [Next Module](../module-2/)
```

### Bước 4: Migration Script

Tạo script tự động để chuyển đổi:

```bash
#!/bin/bash
# migration-script.sh

HUGO_DIR="$1"
OUTPUT_DIR="$2"

if [ -z "$HUGO_DIR" ] || [ -z "$OUTPUT_DIR" ]; then
    echo "Usage: $0 <hugo-directory> <output-directory>"
    exit 1
fi

echo "Starting migration from $HUGO_DIR to $OUTPUT_DIR"

# Create Workshop Studio structure
mkdir -p "$OUTPUT_DIR"/{content/{introduction,prerequisites,modules,cleanup,conclusion},static/{images,code},templates,scripts}

# Convert _index.md files to index.md
find "$HUGO_DIR/content" -name "_index.md" | while read file; do
    # Get relative path and convert
    rel_path=$(realpath --relative-to="$HUGO_DIR/content" "$file")
    new_path="$OUTPUT_DIR/content/${rel_path/_index.md/index.md}"
    
    # Create directory if needed
    mkdir -p "$(dirname "$new_path")"
    
    # Convert content (remove Hugo front matter and shortcodes)
    sed -e '/^---$/,/^---$/d' \
        -e 's/{{% notice \([^}]*\) %}}/> **\1**:/g' \
        -e 's/{{% \/notice %}}/\n/g' \
        -e 's/{{< highlight \([^>]*\) >}}/```\1/g' \
        -e 's/{{< \/highlight >}}/```/g' \
        -e 's/{{% children[^}]*%}}//g' \
        "$file" > "$new_path"
done

# Copy static files
if [ -d "$HUGO_DIR/static" ]; then
    cp -r "$HUGO_DIR/static"/* "$OUTPUT_DIR/static/"
fi

echo "Migration completed!"
```

## 3. Ví dụ thực tế: Chuyển đổi 000011-AWSCLI

### Tạo workshop-config.json cho AWSCLI workshop:

```json
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
```

### Tạo content/index.md:

```markdown
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

## Workshop Architecture
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Local CLI     │───▶│   AWS APIs      │───▶│  AWS Resources  │
│   Environment   │    │                 │    │  (S3, EC2, IAM) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

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

## What You'll Build
During this workshop, you will:
- Set up a complete AWS CLI environment
- Create and manage IAM users and policies
- Work with S3 buckets for file storage
- Launch and manage EC2 instances
- Create automation scripts for common tasks

## Let's Get Started!
Ready to master the AWS CLI? Let's begin with the [Introduction](introduction/) to understand the fundamentals.
```

## 4. Checklist chuyển đổi

### ✅ Pre-migration
- [ ] Backup original Hugo workshop
- [ ] Review Hugo content structure
- [ ] Identify custom shortcodes used
- [ ] List static assets to migrate

### ✅ During migration
- [ ] Create Workshop Studio directory structure
- [ ] Convert config.toml to workshop-config.json
- [ ] Convert _index.md files to index.md
- [ ] Remove Hugo front matter
- [ ] Convert Hugo shortcodes to standard markdown
- [ ] Migrate static assets
- [ ] Update internal links

### ✅ Post-migration
- [ ] Test all internal links
- [ ] Verify images display correctly
- [ ] Review content formatting
- [ ] Test code examples
- [ ] Validate workshop-config.json
- [ ] Create README.md

## 5. Common Issues và Solutions

### Issue 1: Hugo shortcodes không convert được
**Solution:** Tạo mapping table cho từng shortcode:

```bash
# Replace Hugo notices
sed -i 's/{{% notice tip %}}/> 💡 **Tip**:/g' *.md
sed -i 's/{{% notice warning %}}/> ⚠️ **Warning**:/g' *.md
sed -i 's/{{% notice info %}}/> ℹ️ **Info**:/g' *.md
```

### Issue 2: Links bị broken
**Solution:** Update tất cả internal links:

```bash
# Convert Hugo-style links to Workshop Studio format
sed -i 's/\[.*\](\.\.\//[text](..\/modules\//g' *.md
```

### Issue 3: Images không hiển thị
**Solution:** Update image paths:

```bash
# Update image references
sed -i 's/\/images\//..\/..\/static\/images\//g' *.md
```

## 6. Automation Script hoàn chỉnh

Tôi sẽ tạo script tự động để chuyển đổi workshop 000011-AWSCLI:
