# Workshop Images

This directory contains images and diagrams used throughout the workshop documentation.

## Image Guidelines

### File Naming Convention

- Use lowercase with hyphens: `ecs-architecture-overview.png`
- Be descriptive: `module1-lambda-deployment.png`
- Include module number if applicable: `module2-api-gateway-setup.png`

### Image Requirements

- **Format**: PNG (preferred) or JPG
- **Size**: Optimize for web (< 500KB per image)
- **Dimensions**: Max width 1200px for diagrams
- **Alt Text**: Always provide descriptive alt text in markdown

### Architecture Diagrams

Create architecture diagrams using:
- [draw.io](https://draw.io) (free, recommended)
- [Lucidchart](https://www.lucidchart.com)
- [AWS Architecture Icons](https://aws.amazon.com/architecture/icons/)

### Example Usage in Markdown

```markdown
![ECS Architecture Overview](../static/images/ecs-architecture-overview.png)
```

## Required Images

The following images are referenced in documentation but need to be created:

### General Documentation
- `ecs-architecture-overview.png` - Referenced in AWS_WORKSHOP_STUDIO_DEVELOPMENT_GUIDE.md
- `module1-architecture.png` - Referenced in AWS_WORKSHOP_STUDIO_DEVELOPMENT_GUIDE_PART2.md
- `serverless-architecture-hero.png` - Referenced in complete-workshop-example

### Workshop-Specific Images

Add workshop-specific images in subdirectories:
- `ecs-workshop/` - Amazon ECS workshop images
- `cli-workshop/` - AWS CLI workshop images
- `examples/` - Example workshop images

## Contributing Images

When adding images:

1. Optimize file size before committing
2. Use descriptive filenames
3. Update this README with image descriptions
4. Ensure images follow AWS branding guidelines
5. Include source files (.drawio, .psd) if applicable

## Image Optimization Tools

- [TinyPNG](https://tinypng.com/) - PNG compression
- [ImageOptim](https://imageoptim.com/) - Mac image optimizer
- [Squoosh](https://squoosh.app/) - Web-based image optimizer

## License

All images should be original work or properly licensed. Do not include copyrighted images without permission.
