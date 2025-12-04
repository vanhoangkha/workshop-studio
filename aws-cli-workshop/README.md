# AWS CLI Workshop

**Format:** Hugo Static Site Generator
**Level:** Beginner to Intermediate
**Duration:** 2-3 hours
**Status:** Sample/Template

## Overview

This workshop demonstrates how to create an AWS workshop using Hugo framework, allowing you to build a static website with workshop content organized through directory structure and markdown files.

### Purpose

- **Illustrate Hugo Workshop Structure** - Directory structure and file organization
- **Compare with AWS Workshop Studio** - Understand differences between formats
- **Migration Reference** - Foundation for converting to Workshop Studio
- **Best Practices** - Learn effective workshop content organization

### Workshop Information

| Attribute | Details |
|-----------|---------|
| Format | Hugo Static Site Generator |
| Topic | AWS CLI Fundamentals |
| Level | Beginner to Intermediate |
| Duration | 2-3 hours |
| Status | Sample/Template |

## Hugo Workshop Structure

### Directory Structure

```
aws-cli-workshop/
├── config.toml                 # Hugo configuration
├── content/                    # Workshop content
│   ├── _index.md              # Homepage
│   ├── introduction/          # Introduction
│   │   └── _index.md
│   ├── prerequisites/         # Prerequisites
│   │   └── _index.md
│   ├── modules/              # Workshop modules
│   │   ├── module-1/
│   │   │   ├── _index.md
│   │   │   ├── step-1.md
│   │   │   └── step-2.md
│   │   ├── module-2/
│   │   └── ...
│   ├── cleanup/              # Cleanup
│   │   └── _index.md
│   └── conclusion/           # Conclusion
│       └── _index.md
├── static/                   # Static assets
│   ├── images/
│   ├── css/
│   └── js/
├── layouts/                  # Hugo templates
│   ├── _default/
│   ├── partials/
│   └── shortcodes/
└── themes/                   # Hugo theme
    └── workshop-theme/
```

### Hugo Workshop Characteristics

**Advantages:**
- **Static Site** - Fast, secure, easy to host
- **Markdown Support** - Easy content writing
- **Theme System** - Customizable appearance
- **Git-friendly** - Good version control
- **Offline Access** - Can run locally

**Limitations:**
- **Complex Setup** - Requires Hugo installation, theme, configuration
- **No AWS Integration** - Must manually setup infrastructure
- **No Auto-cleanup** - Must manually manage resources
- **No Cost Tracking** - No automatic cost monitoring
- **Limited Interactivity** - Fewer interactive features

## Running Hugo Workshop

### Prerequisites

```bash
# Install Hugo
# macOS
brew install hugo

# Ubuntu/Debian
sudo apt install hugo

# Windows
choco install hugo
```

### Run Workshop

```bash
# Clone repository
git clone https://github.com/aws-samples/workshop-studio.git
cd workshop-studio/aws-cli-workshop

# Run Hugo development server
hugo server -D

# Access at http://localhost:1313
```

### Build Static Site

```bash
# Build static files
hugo

# Deploy static files from public/ directory
```

## Hugo Content Structure

### Frontmatter Example

```yaml
---
title: "Module 1: AWS CLI Installation"
weight: 10
chapter: false
pre: "<b>1. </b>"
---

# AWS CLI Installation

Content goes here...
```

### Hugo Shortcodes

```markdown
{{< notice info >}}
This is an info notice
{{< /notice >}}

{{< tabs >}}
{{% tab name="Linux" %}}
Linux instructions
{{% /tab %}}
{{% tab name="Windows" %}}
Windows instructions
{{% /tab %}}
{{< /tabs >}}
```

## Migration to AWS Workshop Studio

Process for converting this workshop to AWS Workshop Studio format:

### 1. Structure Mapping

```
Hugo Format              →    Workshop Studio Format
├── config.toml         →    workshop-config.json
├── content/_index.md   →    content/index.md
├── content/modules/    →    content/modules/
├── static/            →    static/
└── layouts/           →    templates/
```

### 2. Content Conversion

- **Frontmatter** - YAML → JSON metadata
- **Hugo shortcodes** - → Standard markdown
- **Navigation** - Hugo menu → Workshop Studio navigation
- **Styling** - Hugo theme → Workshop Studio templates

### 3. Configuration Changes

**Hugo config.toml:**
```toml
title = "AWS CLI Workshop"
theme = "workshop-theme"

[params]
  version = "1.0"
  author = "AWS Team"
```

**Workshop Studio workshop-config.json:**
```json
{
  "title": "AWS CLI Workshop",
  "description": "Learn AWS CLI fundamentals",
  "level": "beginner",
  "duration": "2-3 hours",
  "version": "1.0.0"
}
```

## Comparison: Hugo vs AWS Workshop Studio

| Aspect | Hugo Workshop | AWS Workshop Studio |
|--------|---------------|---------------------|
| Setup | Complex (Hugo + Theme) | Simple (JSON config) |
| Hosting | Self-hosted (S3, GitHub Pages) | AWS managed |
| Infrastructure | Self-managed | Auto-provisioning |
| Cost Tracking | Manual | Automatic |
| Cleanup | Manual scripts | Auto-cleanup |
| Interactivity | Limited | Rich interactive features |
| AWS Integration | None | Deep integration |
| Maintenance | High | Low |

## Tools and Scripts

### Migration Script

```bash
# Use available migration script
./migrate-hugo-to-workshop-studio.sh aws-cli-workshop aws-cli-converted
```

### Hugo Development

```bash
# Watch for changes
hugo server --watch --buildDrafts

# Build with specific environment
hugo --environment production
```

## Learning Resources

### Hugo Documentation

- [Hugo Official Docs](https://gohugo.io/documentation/)
- [Hugo Themes](https://themes.gohugo.io/)
- [Hugo Workshop Templates](https://github.com/topics/hugo-workshop)

### Migration Resources

- [Hugo to Workshop Studio Migration Guide](../docs/HUGO_TO_WORKSHOP_STUDIO_MIGRATION.md)
- [AWS Workshop Studio Guidelines](../docs/AWS_WORKSHOP_STUDIO_GUIDELINE.md)

## Conclusion

This Hugo workshop serves as a **reference implementation** to:

1. **Understand Hugo workflow** and traditional workshop structure
2. **Compare with AWS Workshop Studio** to see improvements
3. **Practice migration** from old format to new format
4. **Learn best practices** for both formats

**Recommendation:** Use AWS Workshop Studio for new workshops due to numerous advantages and AWS native integration.

---

**Note:** This workshop was created to illustrate Hugo format and serve as a foundation for migration. See the Amazon ECS Workshop for AWS Workshop Studio format example.
