# 🚀 AWS Workshop Studio Collection

Bộ sưu tập các workshop AWS được chuyển đổi và tối ưu hóa cho AWS Workshop Studio platform.

## 📋 Tổng quan

Repository này chứa các workshop AWS đã được chuyển đổi từ định dạng Hugo sang AWS Workshop Studio format, cùng với các công cụ và hướng dẫn để tạo và quản lý workshop chất lượng cao.

## 🏗️ Cấu trúc Project

```
workshop-studio/
├── README.md                                    # File này
├── 📁 000011-AWSCLI/                           # Workshop Hugo gốc
├── 📁 000011-AWSCLI-converted/                 # Workshop đã chuyển đổi
├── 📁 developing-on-amazon-ecs/                # Workshop ECS
├── 🔧 migrate-hugo-to-workshop-studio.sh       # Script migration tự động
├── 📖 AWS_WORKSHOP_STUDIO_GUIDELINE.md         # Hướng dẫn tạo workshop
├── 📖 HUGO_TO_WORKSHOP_STUDIO_MIGRATION.md     # Hướng dẫn migration
└── 📖 MIGRATION_COMPLETE_GUIDE.md              # Hướng dẫn hoàn chỉnh
```

## 🎯 Workshop có sẵn

### 1. AWS CLI Workshop (000011-AWSCLI-converted)
- **Mô tả**: Workshop toàn diện về AWS Command Line Interface
- **Thời gian**: 2-3 giờ
- **Cấp độ**: Beginner đến Intermediate
- **Nội dung**:
  - Cài đặt và cấu hình AWS CLI
  - Quản lý IAM users và roles
  - Làm việc với S3, EC2, Lambda
  - Best practices và troubleshooting

### 2. Developing on Amazon ECS
- **Mô tả**: Workshop phát triển ứng dụng trên Amazon ECS
- **Thời gian**: 3-4 giờ
- **Cấp độ**: Intermediate
- **Nội dung**:
  - Container fundamentals
  - ECS cluster setup
  - Service deployment và scaling
  - CI/CD integration

## 🛠️ Công cụ Migration

### Script Migration Tự động
```bash
./migrate-hugo-to-workshop-studio.sh <hugo-workshop-path> [output-directory]
```

**Tính năng**:
- ✅ Chuyển đổi cấu trúc thư mục Hugo sang Workshop Studio
- ✅ Tạo `workshop-config.json` tự động
- ✅ Xử lý metadata và frontmatter
- ✅ Tối ưu hóa hình ảnh và assets
- ✅ Tạo navigation structure
- ✅ Validation và error checking

## 📚 Tài liệu hướng dẫn

| Tài liệu | Mô tả | Mục đích |
|----------|-------|----------|
| [AWS Workshop Studio Guideline](./AWS_WORKSHOP_STUDIO_GUIDELINE.md) | Hướng dẫn tạo workshop từ đầu | Cho người tạo workshop mới |
| [Hugo to Workshop Studio Migration](./HUGO_TO_WORKSHOP_STUDIO_MIGRATION.md) | Hướng dẫn migration chi tiết | Cho việc chuyển đổi workshop |
| [Migration Complete Guide](./MIGRATION_COMPLETE_GUIDE.md) | Hướng dẫn hoàn chỉnh sau migration | Kiểm tra và hoàn thiện |

## 🚀 Bắt đầu nhanh

### 1. Clone Repository
```bash
git clone https://github.com/vanhoangkha/workshop-studio.git
cd workshop-studio
```

### 2. Chạy Workshop có sẵn
```bash
# Chọn workshop muốn chạy
cd 000011-AWSCLI-converted
# hoặc
cd developing-on-amazon-ecs

# Xem hướng dẫn trong README.md của từng workshop
```

### 3. Migration Workshop Hugo
```bash
# Cấp quyền thực thi cho script
chmod +x migrate-hugo-to-workshop-studio.sh

# Chạy migration
./migrate-hugo-to-workshop-studio.sh /path/to/hugo/workshop
```

## 📋 Yêu cầu hệ thống

### Môi trường phát triển
- **OS**: Linux/macOS/Windows (WSL)
- **Tools**: Git, Bash, Text Editor
- **Optional**: AWS CLI, Docker

### Để chạy workshop
- **AWS Account**: Có quyền truy cập các service cần thiết
- **Browser**: Chrome/Firefox/Safari (latest version)
- **Network**: Kết nối internet ổn định

## 🔧 Cấu hình Workshop Studio

### workshop-config.json Template
```json
{
  "title": "Workshop Title",
  "description": "Workshop description",
  "level": "beginner|intermediate|advanced",
  "duration": "2-3 hours",
  "auto_destroy": true,
  "tags": ["aws", "cli", "beginner"],
  "regions": ["us-east-1", "us-west-2"],
  "architecture": "x86_64"
}
```

### Cấu trúc Content chuẩn
```
content/
├── index.md              # Homepage
├── introduction/         # Giới thiệu workshop
├── prerequisites/        # Yêu cầu trước khi bắt đầu
├── modules/             # Các module chính
│   ├── module-1/
│   ├── module-2/
│   └── ...
├── cleanup/             # Dọn dẹp resources
└── conclusion/          # Kết luận và next steps
```

## 🎨 Best Practices

### Viết nội dung Workshop
- ✅ Sử dụng ngôn ngữ rõ ràng, dễ hiểu
- ✅ Chia nhỏ thành các bước cụ thể
- ✅ Cung cấp screenshots và code examples
- ✅ Thêm troubleshooting section
- ✅ Test kỹ trước khi publish

### Quản lý Resources
- ✅ Sử dụng CloudFormation/CDK cho infrastructure
- ✅ Implement auto-cleanup
- ✅ Tính toán cost và set limits
- ✅ Cung cấp cleanup instructions

### Security
- ✅ Sử dụng least privilege principle
- ✅ Không hardcode credentials
- ✅ Sử dụng temporary credentials
- ✅ Regular security review

## 🤝 Đóng góp

### Cách đóng góp
1. Fork repository
2. Tạo feature branch: `git checkout -b feature/amazing-workshop`
3. Commit changes: `git commit -m 'Add amazing workshop'`
4. Push to branch: `git push origin feature/amazing-workshop`
5. Tạo Pull Request

### Quy tắc đóng góp
- Tuân thủ coding standards
- Viết documentation đầy đủ
- Test kỹ trước khi submit
- Sử dụng commit message rõ ràng

## 📞 Hỗ trợ

### Báo lỗi
- Tạo [GitHub Issue](https://github.com/vanhoangkha/workshop-studio/issues)
- Cung cấp thông tin chi tiết về lỗi
- Attach logs và screenshots nếu có

### Liên hệ
- **Email**: khavan.work@gmail.com
- **GitHub**: [@vanhoangkha](https://github.com/vanhoangkha)

## 📄 License

Dự án này được phân phối dưới MIT License. Xem file [LICENSE](LICENSE) để biết thêm chi tiết.

## 🙏 Acknowledgments

- AWS Workshop Studio team
- AWS Community
- Contributors và testers

## 📈 Roadmap

### Q2 2024
- [x] Migration tool hoàn chỉnh
- [x] AWS CLI workshop
- [x] ECS workshop
- [ ] Lambda workshop

### Q3 2024
- [ ] S3 advanced workshop
- [ ] Security best practices workshop
- [ ] Multi-language support
- [ ] Interactive components

### Q4 2024
- [ ] Advanced networking workshop
- [ ] DevOps pipeline workshop
- [ ] Cost optimization workshop
- [ ] Workshop analytics

---

⭐ **Nếu project này hữu ích, hãy star repository để ủng hộ!**

📝 **Cập nhật lần cuối**: 16/06/2024
