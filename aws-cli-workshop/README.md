#  AWS CLI Workshop (Hugo Format - Sample)

Đây là workshop mẫu sử dụng **Hugo static site generator** - định dạng workshop truyền thống trước khi AWS Workshop Studio ra đời.

##  Tổng quan Workshop

Workshop này minh họa cách tạo workshop AWS sử dụng Hugo framework, cho phép tạo static website với nội dung workshop được tổ chức theo cấu trúc thư mục và markdown files.

###  Mục đích của Workshop mẫu này

-  **Minh họa Hugo Workshop Structure**: Cấu trúc thư mục và file organization
-  **So sánh với AWS Workshop Studio**: Hiểu sự khác biệt giữa 2 format
-  **Migration Reference**: Làm cơ sở cho việc chuyển đổi sang Workshop Studio
-  **Best Practices**: Học cách tổ chức nội dung workshop hiệu quả

###  Thông tin Workshop

| **Thuộc tính** | **Chi tiết** |
|----------------|--------------|
| **Format** | Hugo Static Site Generator |
| **Chủ đề** | AWS CLI Fundamentals |
| **Cấp độ** | Beginner to Intermediate |
| **Thời gian** | 2-3 giờ |
| **Trạng thái** | Sample/Template |

##  Cấu trúc Hugo Workshop

### Cấu trúc thư mục Hugo:
```
aws-cli-workshop/ (Hugo Format)
├── config.toml                 # Hugo configuration
├── content/                    # Workshop content
│   ├── _index.md              # Homepage
│   ├── introduction/          # Giới thiệu
│   │   └── _index.md
│   ├── prerequisites/         # Yêu cầu
│   │   └── _index.md
│   ├── modules/              # Các module
│   │   ├── module-1/
│   │   │   ├── _index.md
│   │   │   ├── step-1.md
│   │   │   └── step-2.md
│   │   ├── module-2/
│   │   └── ...
│   ├── cleanup/              # Dọn dẹp
│   │   └── _index.md
│   └── conclusion/           # Kết luận
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

### Đặc điểm Hugo Workshop:

####  **Ưu điểm:**
- **Static Site**: Nhanh, bảo mật, dễ host
- **Markdown Support**: Viết nội dung dễ dàng
- **Theme System**: Customizable appearance
- **Git-friendly**: Version control tốt
- **Offline Access**: Có thể chạy local

####  **Hạn chế:**
- **Setup phức tạp**: Cần cài Hugo, theme, config
- **Không có tích hợp AWS**: Phải tự setup infrastructure
- **Không có auto-cleanup**: Phải tự quản lý resources
- **Không có cost tracking**: Không theo dõi chi phí tự động
- **Limited interactivity**: Ít tính năng tương tác

##  Cách chạy Hugo Workshop

### Prerequisites:
```bash
# Cài đặt Hugo
# macOS
brew install hugo

# Ubuntu/Debian
sudo apt install hugo

# Windows
choco install hugo
```

### Chạy workshop:
```bash
# Clone repository
git clone https://github.com/vanhoangkha/workshop-studio.git
cd workshop-studio/aws-cli-workshop

# Chạy Hugo development server
hugo server -D

# Truy cập http://localhost:1313
```

### Build static site:
```bash
# Build static files
hugo

# Deploy static files từ thư mục public/
```

##  Hugo Content Structure

### Frontmatter Example:
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

### Hugo Shortcodes:
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

##  Migration từ Hugo sang AWS Workshop Studio

Quá trình chuyển đổi workshop này sang AWS Workshop Studio format:

### 1. **Structure Mapping:**
```
Hugo Format              →    Workshop Studio Format
├── config.toml         →    workshop-config.json
├── content/_index.md   →    content/index.md
├── content/modules/    →    content/modules/
├── static/            →    static/
└── layouts/           →    templates/
```

### 2. **Content Conversion:**
- **Frontmatter**: YAML → JSON metadata
- **Hugo shortcodes**: → Standard markdown
- **Navigation**: Hugo menu → Workshop Studio navigation
- **Styling**: Hugo theme → Workshop Studio templates

### 3. **Configuration Changes:**
```toml
# Hugo config.toml
title = "AWS CLI Workshop"
theme = "workshop-theme"

[params]
  version = "1.0"
  author = "AWS Team"
```

```json
// Workshop Studio workshop-config.json
{
  "title": "AWS CLI Workshop",
  "description": "Learn AWS CLI fundamentals",
  "level": "beginner",
  "duration": "2-3 hours",
  "version": "1.0.0"
}
```

## 🆚 So sánh Hugo vs AWS Workshop Studio

| **Aspect** | **Hugo Workshop** | **AWS Workshop Studio** |
|------------|-------------------|--------------------------|
| **Setup** | Phức tạp (Hugo + Theme) | Đơn giản (JSON config) |
| **Hosting** | Tự host (S3, GitHub Pages) | AWS managed |
| **Infrastructure** | Tự quản lý | Auto-provisioning |
| **Cost Tracking** | Manual | Automatic |
| **Cleanup** | Manual scripts | Auto-cleanup |
| **Interactivity** | Limited | Rich interactive features |
| **AWS Integration** | None | Deep integration |
| **Maintenance** | High | Low |

##  Tools và Scripts

### Migration Script:
```bash
# Sử dụng migration script có sẵn
./migrate-hugo-to-workshop-studio.sh aws-cli-workshop aws-cli-converted
```

### Hugo Development:
```bash
# Watch for changes
hugo server --watch --buildDrafts

# Build with specific environment
hugo --environment production
```

##  Learning Resources

### Hugo Documentation:
- [Hugo Official Docs](https://gohugo.io/documentation/)
- [Hugo Themes](https://themes.gohugo.io/)
- [Hugo Workshop Templates](https://github.com/topics/hugo-workshop)

### Migration Resources:
- [Hugo to Workshop Studio Migration Guide](../HUGO_TO_WORKSHOP_STUDIO_MIGRATION.md)
- [AWS Workshop Studio Guidelines](../AWS_WORKSHOP_STUDIO_GUIDELINE.md)

##  Kết luận

Workshop Hugo này serve như một **reference implementation** để:

1. **Hiểu Hugo workflow** và cấu trúc workshop truyền thống
2. **So sánh với AWS Workshop Studio** để thấy được improvements
3. **Practice migration** từ format cũ sang format mới
4. **Learn best practices** cho cả 2 formats

**Khuyến nghị**: Sử dụng AWS Workshop Studio cho workshops mới vì có nhiều advantages và AWS native integration.

---

 *Workshop mẫu này được tạo để minh họa Hugo format và làm cơ sở cho migration*
 *Xem Amazon ECS Workshop để thấy AWS Workshop Studio format*
