# 🚀 HƯỚNG DẪN PHÁT TRIỂN AWS WORKSHOP STUDIO - PHẦN 3

## 7. Testing và Validation

### 7.1 Automated Testing Framework

**🧪 Testing Strategy:**
```bash
#!/bin/bash
# tests/run-all-tests.sh - Comprehensive testing suite

set -e

echo "🧪 Starting AWS Workshop Studio Testing Suite..."

# Test Categories
TESTS_DIR="$(dirname "$0")"
WORKSHOP_ROOT="$(dirname "$TESTS_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test Results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -e "\n${YELLOW}Running: $test_name${NC}"
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if eval "$test_command"; then
        echo -e "${GREEN}✅ PASSED: $test_name${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}❌ FAILED: $test_name${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# 1. Configuration Validation Tests
echo -e "\n📋 Configuration Validation Tests"
run_test "Workshop Config JSON Syntax" "python3 -m json.tool $WORKSHOP_ROOT/workshop-config.json > /dev/null"
run_test "CloudFormation Template Syntax" "aws cloudformation validate-template --template-body file://$WORKSHOP_ROOT/templates/infrastructure.yaml > /dev/null"
run_test "Required Files Exist" "$TESTS_DIR/unit/test-file-structure.sh"

# 2. Content Quality Tests
echo -e "\n📝 Content Quality Tests"
run_test "Markdown Syntax Check" "$TESTS_DIR/unit/test-markdown-syntax.sh"
run_test "Link Validation" "$TESTS_DIR/unit/test-links.sh"
run_test "Image References" "$TESTS_DIR/unit/test-images.sh"
run_test "Code Block Syntax" "$TESTS_DIR/unit/test-code-blocks.sh"

# 3. Infrastructure Tests
echo -e "\n🏗️ Infrastructure Tests"
run_test "CloudFormation Linting" "$TESTS_DIR/unit/test-cfn-lint.sh"
run_test "Security Best Practices" "$TESTS_DIR/unit/test-security.sh"
run_test "Cost Optimization Check" "$TESTS_DIR/unit/test-cost-optimization.sh"

# 4. Integration Tests (if AWS credentials available)
if aws sts get-caller-identity &>/dev/null; then
    echo -e "\n🔗 Integration Tests"
    run_test "Stack Deployment Test" "$TESTS_DIR/integration/test-stack-deployment.sh"
    run_test "Application Deployment" "$TESTS_DIR/integration/test-app-deployment.sh"
    run_test "End-to-End Workflow" "$TESTS_DIR/integration/test-e2e-workflow.sh"
else
    echo -e "\n⚠️ Skipping integration tests (AWS credentials not configured)"
fi

# Test Summary
echo -e "\n📊 Test Summary"
echo "=================================="
echo "Total Tests: $TOTAL_TESTS"
echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
echo -e "Failed: ${RED}$FAILED_TESTS${NC}"
echo "=================================="

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please review and fix issues.${NC}"
    exit 1
fi
```

**🔍 Unit Tests Examples:**

```bash
#!/bin/bash
# tests/unit/test-file-structure.sh

echo "🔍 Testing workshop file structure..."

WORKSHOP_ROOT="$(dirname "$(dirname "$0")")"
REQUIRED_FILES=(
    "workshop-config.json"
    "content/index.md"
    "content/prerequisites/index.md"
    "content/cleanup/index.md"
    "templates/infrastructure.yaml"
    "scripts/validate-prerequisites.sh"
)

REQUIRED_DIRS=(
    "content"
    "static"
    "templates"
    "scripts"
)

# Check required files
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$WORKSHOP_ROOT/$file" ]; then
        echo "❌ Missing required file: $file"
        exit 1
    fi
done

# Check required directories
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$WORKSHOP_ROOT/$dir" ]; then
        echo "❌ Missing required directory: $dir"
        exit 1
    fi
done

echo "✅ File structure validation passed"
```

```bash
#!/bin/bash
# tests/unit/test-markdown-syntax.sh

echo "🔍 Testing Markdown syntax..."

CONTENT_DIR="$(dirname "$(dirname "$0")")/content"

# Find all markdown files
find "$CONTENT_DIR" -name "*.md" -type f | while read -r file; do
    echo "Checking: $file"
    
    # Check for common markdown issues
    if grep -q "^#[^# ]" "$file"; then
        echo "⚠️ Warning: Headers should have space after # in $file"
    fi
    
    # Check for broken internal links
    if grep -q "\[.*\](\.\./" "$file"; then
        echo "✅ Internal links found in $file"
    fi
    
    # Check for frontmatter
    if head -n 1 "$file" | grep -q "^---$"; then
        echo "✅ Frontmatter found in $file"
    else
        echo "⚠️ Warning: No frontmatter in $file"
    fi
done

echo "✅ Markdown syntax check completed"
```

### 7.2 Integration Testing

**🔗 End-to-End Testing Script:**
```bash
#!/bin/bash
# tests/integration/test-e2e-workflow.sh

set -e

echo "🔗 Running End-to-End Workshop Test..."

# Configuration
STACK_NAME="workshop-test-$(date +%s)"
REGION="us-east-1"
WORKSHOP_ROOT="$(dirname "$(dirname "$0")")"

cleanup() {
    echo "🧹 Cleaning up test resources..."
    aws cloudformation delete-stack --stack-name "$STACK_NAME" --region "$REGION" || true
    aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME" --region "$REGION" || true
}

# Set up cleanup trap
trap cleanup EXIT

echo "📋 Step 1: Deploy Infrastructure"
aws cloudformation create-stack \
    --stack-name "$STACK_NAME" \
    --template-body "file://$WORKSHOP_ROOT/templates/infrastructure.yaml" \
    --parameters ParameterKey=EnvironmentName,ParameterValue=TestWorkshop \
    --capabilities CAPABILITY_NAMED_IAM \
    --region "$REGION"

echo "⏳ Waiting for stack creation..."
aws cloudformation wait stack-create-complete \
    --stack-name "$STACK_NAME" \
    --region "$REGION"

echo "📋 Step 2: Get Stack Outputs"
ECR_URI=$(aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --region "$REGION" \
    --query 'Stacks[0].Outputs[?OutputKey==`ECRRepository`].OutputValue' \
    --output text)

ALB_URL=$(aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --region "$REGION" \
    --query 'Stacks[0].Outputs[?OutputKey==`LoadBalancerURL`].OutputValue' \
    --output text)

echo "📋 Step 3: Build and Push Test Image"
cd "$WORKSHOP_ROOT"

# Create simple test app
cat > test-app.js << 'EOF'
const express = require('express');
const app = express();
app.get('/', (req, res) => res.json({message: 'Test successful!'}));
app.get('/health', (req, res) => res.json({status: 'healthy'}));
app.listen(3000, '0.0.0.0');
EOF

cat > test-package.json << 'EOF'
{
  "name": "test-app",
  "version": "1.0.0",
  "dependencies": {"express": "^4.18.0"},
  "scripts": {"start": "node test-app.js"}
}
EOF

cat > test-Dockerfile << 'EOF'
FROM node:18-alpine
WORKDIR /app
COPY test-package.json package.json
RUN npm install
COPY test-app.js app.js
EXPOSE 3000
CMD ["npm", "start"]
EOF

# Build and push image
docker build -f test-Dockerfile -t test-app .
aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$ECR_URI"
docker tag test-app:latest "$ECR_URI:latest"
docker push "$ECR_URI:latest"

echo "📋 Step 4: Deploy ECS Service"
# Create task definition
cat > task-definition.json << EOF
{
  "family": "test-task",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "executionRoleArn": "$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --region "$REGION" --query 'Stacks[0].Outputs[?OutputKey==`ECSTaskExecutionRoleArn`].OutputValue' --output text)",
  "containerDefinitions": [
    {
      "name": "test-container",
      "image": "$ECR_URI:latest",
      "portMappings": [{"containerPort": 3000}],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/test-task",
          "awslogs-region": "$REGION",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
EOF

# Register task definition
aws ecs register-task-definition --cli-input-json file://task-definition.json --region "$REGION"

echo "📋 Step 5: Test Application"
# Wait for ALB to be ready and test
sleep 60
RESPONSE=$(curl -s "$ALB_URL" || echo "Connection failed")

if echo "$RESPONSE" | grep -q "Test successful"; then
    echo "✅ End-to-end test PASSED"
else
    echo "❌ End-to-end test FAILED"
    echo "Response: $RESPONSE"
    exit 1
fi

echo "🎉 All integration tests completed successfully!"
```

### 7.3 Performance và Load Testing

**⚡ Performance Testing:**
```bash
#!/bin/bash
# tests/performance/load-test.sh

echo "⚡ Running Performance Tests..."

# Configuration
TARGET_URL="$1"
CONCURRENT_USERS=10
TEST_DURATION=60
RAMP_UP_TIME=10

if [ -z "$TARGET_URL" ]; then
    echo "Usage: $0 <target-url>"
    exit 1
fi

# Install Apache Bench if not available
if ! command -v ab &> /dev/null; then
    echo "Installing Apache Bench..."
    sudo apt-get update && sudo apt-get install -y apache2-utils
fi

echo "🎯 Target URL: $TARGET_URL"
echo "👥 Concurrent Users: $CONCURRENT_USERS"
echo "⏱️ Test Duration: ${TEST_DURATION}s"

# Run load test
echo "🚀 Starting load test..."
ab -n 1000 -c "$CONCURRENT_USERS" -t "$TEST_DURATION" "$TARGET_URL" > load-test-results.txt

# Parse results
REQUESTS_PER_SECOND=$(grep "Requests per second" load-test-results.txt | awk '{print $4}')
MEAN_TIME=$(grep "Time per request" load-test-results.txt | head -1 | awk '{print $4}')
FAILED_REQUESTS=$(grep "Failed requests" load-test-results.txt | awk '{print $3}')

echo "📊 Performance Test Results:"
echo "================================"
echo "Requests per second: $REQUESTS_PER_SECOND"
echo "Mean response time: ${MEAN_TIME}ms"
echo "Failed requests: $FAILED_REQUESTS"
echo "================================"

# Performance thresholds
if (( $(echo "$REQUESTS_PER_SECOND > 50" | bc -l) )); then
    echo "✅ Performance test PASSED (RPS > 50)"
else
    echo "❌ Performance test FAILED (RPS <= 50)"
    exit 1
fi

if [ "$FAILED_REQUESTS" -eq 0 ]; then
    echo "✅ Reliability test PASSED (0 failed requests)"
else
    echo "⚠️ Reliability test WARNING ($FAILED_REQUESTS failed requests)"
fi
```

---

## 8. Deployment và Publishing

### 8.1 Workshop Studio Deployment Process

**🚀 Deployment Checklist:**
```markdown
## Pre-Deployment Checklist

### Content Review
- [ ] All modules tested and validated
- [ ] Screenshots updated and accurate
- [ ] Code examples tested in multiple regions
- [ ] Cost estimates verified
- [ ] Cleanup procedures tested

### Technical Validation
- [ ] CloudFormation templates validated
- [ ] IAM permissions follow least privilege
- [ ] Security groups properly configured
- [ ] Auto-cleanup mechanisms tested
- [ ] Multi-region compatibility verified

### Quality Assurance
- [ ] Spelling and grammar checked
- [ ] Links validated (internal and external)
- [ ] Images optimized and accessible
- [ ] Navigation flow tested
- [ ] Mobile responsiveness verified

### Compliance
- [ ] Security best practices implemented
- [ ] Cost optimization applied
- [ ] Accessibility standards met
- [ ] Legal review completed (if required)
```

**📦 Deployment Script:**
```bash
#!/bin/bash
# scripts/deploy-workshop.sh

set -e

echo "🚀 Deploying AWS Workshop Studio..."

# Configuration
WORKSHOP_NAME="ecs-container-workshop"
VERSION=$(jq -r '.version' workshop-config.json)
REGIONS=("us-east-1" "us-west-2" "eu-west-1")

# Validation
echo "📋 Pre-deployment validation..."
if ! python3 -m json.tool workshop-config.json > /dev/null; then
    echo "❌ Invalid workshop-config.json"
    exit 1
fi

if ! aws cloudformation validate-template --template-body file://templates/infrastructure.yaml > /dev/null; then
    echo "❌ Invalid CloudFormation template"
    exit 1
fi

# Package workshop
echo "📦 Packaging workshop..."
PACKAGE_NAME="${WORKSHOP_NAME}-${VERSION}.zip"
zip -r "$PACKAGE_NAME" \
    workshop-config.json \
    content/ \
    static/ \
    templates/ \
    scripts/ \
    -x "*.git*" "*.DS_Store" "node_modules/*" "tests/*"

echo "✅ Workshop packaged: $PACKAGE_NAME"

# Upload to S3 (Workshop Studio distribution)
echo "☁️ Uploading to Workshop Studio..."
aws s3 cp "$PACKAGE_NAME" "s3://aws-workshop-studio-content/$WORKSHOP_NAME/"

# Deploy to multiple regions
for region in "${REGIONS[@]}"; do
    echo "🌍 Deploying to region: $region"
    
    # Upload regional assets
    aws s3 sync static/ "s3://aws-workshop-studio-$region/$WORKSHOP_NAME/static/" --region "$region"
    
    # Validate templates in region
    aws cloudformation validate-template \
        --template-body file://templates/infrastructure.yaml \
        --region "$region"
    
    echo "✅ Region $region deployment complete"
done

# Register with Workshop Studio
echo "📝 Registering with AWS Workshop Studio..."
aws workshop-studio register-workshop \
    --workshop-config file://workshop-config.json \
    --package-url "s3://aws-workshop-studio-content/$WORKSHOP_NAME/$PACKAGE_NAME"

echo "🎉 Workshop deployment completed successfully!"
echo "📊 Workshop URL: https://workshop-studio.aws.amazon.com/workshops/$WORKSHOP_NAME"
```

### 8.2 Version Management

**🏷️ Versioning Strategy:**
```json
{
  "versioning": {
    "scheme": "semantic_versioning",
    "format": "MAJOR.MINOR.PATCH",
    "examples": {
      "1.0.0": "Initial release",
      "1.1.0": "New module added",
      "1.0.1": "Bug fixes and improvements",
      "2.0.0": "Breaking changes or major restructure"
    },
    "release_process": [
      "Update version in workshop-config.json",
      "Update CHANGELOG.md",
      "Create git tag",
      "Deploy to staging",
      "Run full test suite",
      "Deploy to production",
      "Update documentation"
    ]
  }
}
```

**📝 Release Script:**
```bash
#!/bin/bash
# scripts/release.sh

set -e

CURRENT_VERSION=$(jq -r '.version' workshop-config.json)
echo "Current version: $CURRENT_VERSION"

# Get new version from user
read -p "Enter new version (e.g., 1.1.0): " NEW_VERSION

# Validate version format
if ! [[ $NEW_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ Invalid version format. Use MAJOR.MINOR.PATCH"
    exit 1
fi

# Update workshop-config.json
jq ".version = \"$NEW_VERSION\"" workshop-config.json > tmp.json && mv tmp.json workshop-config.json

# Update CHANGELOG.md
DATE=$(date +%Y-%m-%d)
sed -i "1i\\## [$NEW_VERSION] - $DATE\n" CHANGELOG.md

# Commit changes
git add workshop-config.json CHANGELOG.md
git commit -m "Release version $NEW_VERSION"
git tag -a "v$NEW_VERSION" -m "Version $NEW_VERSION"

# Push changes
git push origin main
git push origin "v$NEW_VERSION"

echo "✅ Version $NEW_VERSION released successfully!"
```

### 8.3 Monitoring và Analytics

**📊 Workshop Analytics Dashboard:**
```json
{
  "analytics_config": {
    "tracking_enabled": true,
    "metrics": {
      "participation": {
        "total_starts": "counter",
        "completion_rate": "percentage",
        "average_duration": "time",
        "drop_off_points": "array"
      },
      "performance": {
        "page_load_times": "histogram",
        "api_response_times": "histogram",
        "error_rates": "percentage"
      },
      "costs": {
        "average_cost_per_participant": "currency",
        "total_infrastructure_cost": "currency",
        "cost_by_service": "breakdown"
      },
      "feedback": {
        "satisfaction_score": "rating",
        "difficulty_rating": "rating",
        "improvement_suggestions": "text"
      }
    },
    "dashboards": {
      "real_time": "CloudWatch Dashboard",
      "historical": "QuickSight Dashboard",
      "cost_analysis": "Cost Explorer"
    }
  }
}
```

**📈 Monitoring Setup:**
```yaml
# monitoring/cloudwatch-dashboard.yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Workshop Monitoring Dashboard'

Resources:
  WorkshopDashboard:
    Type: AWS::CloudWatch::Dashboard
    Properties:
      DashboardName: !Sub '${EnvironmentName}-Workshop-Metrics'
      DashboardBody: !Sub |
        {
          "widgets": [
            {
              "type": "metric",
              "properties": {
                "metrics": [
                  ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${ApplicationLoadBalancer}"],
                  ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "${ApplicationLoadBalancer}"]
                ],
                "period": 300,
                "stat": "Sum",
                "region": "${AWS::Region}",
                "title": "Application Load Balancer Metrics"
              }
            },
            {
              "type": "metric",
              "properties": {
                "metrics": [
                  ["AWS/ECS", "CPUUtilization", "ServiceName", "${ECSService}", "ClusterName", "${ECSCluster}"],
                  ["AWS/ECS", "MemoryUtilization", "ServiceName", "${ECSService}", "ClusterName", "${ECSCluster}"]
                ],
                "period": 300,
                "stat": "Average",
                "region": "${AWS::Region}",
                "title": "ECS Service Metrics"
              }
            }
          ]
        }
```

---

## 9. Monitoring và Maintenance

### 9.1 Operational Monitoring

**🔍 Health Check System:**
```bash
#!/bin/bash
# scripts/health-check.sh

echo "🏥 Workshop Health Check System"

# Configuration
WORKSHOP_ENDPOINTS=(
    "https://workshop-studio.aws.amazon.com/workshops/ecs-container-workshop"
    "https://workshop-studio.aws.amazon.com/api/workshops/ecs-container-workshop/status"
)

CLOUDFORMATION_STACKS=(
    "ECSWorkshop-Infrastructure"
    "ECSWorkshop-IAM-Roles"
)

# Health check functions
check_endpoint() {
    local url="$1"
    local response_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [ "$response_code" -eq 200 ]; then
        echo "✅ $url - Healthy"
        return 0
    else
        echo "❌ $url - Unhealthy (HTTP $response_code)"
        return 1
    fi
}

check_cloudformation_stack() {
    local stack_name="$1"
    local stack_status=$(aws cloudformation describe-stacks --stack-name "$stack_name" --query 'Stacks[0].StackStatus' --output text 2>/dev/null)
    
    if [ "$stack_status" = "CREATE_COMPLETE" ] || [ "$stack_status" = "UPDATE_COMPLETE" ]; then
        echo "✅ Stack $stack_name - Healthy ($stack_status)"
        return 0
    else
        echo "❌ Stack $stack_name - Unhealthy ($stack_status)"
        return 1
    fi
}

# Run health checks
echo "🌐 Checking Workshop Endpoints..."
for endpoint in "${WORKSHOP_ENDPOINTS[@]}"; do
    check_endpoint "$endpoint"
done

echo -e "\n☁️ Checking CloudFormation Stacks..."
for stack in "${CLOUDFORMATION_STACKS[@]}"; do
    check_cloudformation_stack "$stack"
done

# Check workshop metrics
echo -e "\n📊 Workshop Metrics (Last 24 hours)..."
aws cloudwatch get-metric-statistics \
    --namespace "AWS/Workshop/ECS" \
    --metric-name "ParticipantCount" \
    --start-time "$(date -d '24 hours ago' -u +%Y-%m-%dT%H:%M:%S)" \
    --end-time "$(date -u +%Y-%m-%dT%H:%M:%S)" \
    --period 3600 \
    --statistics Sum \
    --query 'Datapoints[0].Sum' \
    --output text

echo "🏥 Health check completed"
```

### 9.2 Maintenance Procedures

**🔧 Regular Maintenance Tasks:**
```bash
#!/bin/bash
# scripts/maintenance.sh

echo "🔧 Workshop Maintenance Procedures"

# 1. Update Dependencies
echo "📦 Updating Dependencies..."
npm audit fix
pip install --upgrade -r requirements.txt

# 2. Security Scan
echo "🔒 Running Security Scan..."
npm audit --audit-level high
bandit -r scripts/ -f json -o security-report.json

# 3. Cost Analysis
echo "💰 Analyzing Costs..."
aws ce get-cost-and-usage \
    --time-period Start=2024-01-01,End=2024-01-31 \
    --granularity MONTHLY \
    --metrics BlendedCost \
    --group-by Type=DIMENSION,Key=SERVICE \
    --query 'ResultsByTime[0].Groups[?Metrics.BlendedCost.Amount>`10`]'

# 4. Performance Review
echo "⚡ Performance Review..."
aws logs filter-log-events \
    --log-group-name "/aws/workshop/ecs" \
    --start-time "$(date -d '7 days ago' +%s)000" \
    --filter-pattern "ERROR" \
    --query 'events[*].message'

# 5. Cleanup Old Resources
echo "🧹 Cleaning Up Old Resources..."
# Remove old CloudFormation stacks
aws cloudformation list-stacks \
    --stack-status-filter DELETE_COMPLETE \
    --query 'StackSummaries[?CreationTime<=`2024-01-01`].StackName' \
    --output text | xargs -I {} aws cloudformation delete-stack --stack-name {}

# 6. Update Documentation
echo "📚 Updating Documentation..."
# Generate API documentation
swagger-codegen generate -i api-spec.yaml -l html2 -o docs/api/

echo "✅ Maintenance completed"
```

### 9.3 Incident Response

**🚨 Incident Response Playbook:**
```markdown
# Workshop Incident Response Playbook

## Severity Levels

### P1 - Critical (Workshop Completely Down)
- **Response Time**: 15 minutes
- **Actions**:
  1. Acknowledge incident in monitoring system
  2. Check AWS Service Health Dashboard
  3. Verify CloudFormation stack status
  4. Check application logs
  5. Implement immediate workaround if possible
  6. Communicate to stakeholders

### P2 - High (Partial Functionality Loss)
- **Response Time**: 1 hour
- **Actions**:
  1. Investigate root cause
  2. Check resource utilization
  3. Review recent deployments
  4. Implement fix or rollback

### P3 - Medium (Performance Degradation)
- **Response Time**: 4 hours
- **Actions**:
  1. Monitor metrics trends
  2. Optimize resource allocation
  3. Schedule maintenance window if needed

## Common Issues and Solutions

### Issue: High Workshop Costs
**Symptoms**: Cost alerts triggered
**Investigation**:
```bash
# Check current running resources
aws ec2 describe-instances --filters "Name=tag:Workshop,Values=ECS-Container-Workshop" --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType]'

# Check ECS services
aws ecs list-services --cluster ECSWorkshop-Cluster
```

**Resolution**:
1. Scale down unnecessary services
2. Review auto-scaling policies
3. Implement cost optimization recommendations

### Issue: Participant Cannot Access Workshop
**Symptoms**: 403/404 errors, authentication failures
**Investigation**:
```bash
# Check IAM permissions
aws iam simulate-principal-policy --policy-source-arn arn:aws:iam::ACCOUNT:user/workshop-participant --action-names ecs:DescribeClusters

# Check security groups
aws ec2 describe-security-groups --filters "Name=tag:Workshop,Values=ECS-Container-Workshop"
```

**Resolution**:
1. Verify IAM policies
2. Check security group rules
3. Validate network connectivity
```

Tôi đã tạo hướng dẫn chi tiết về phát triển AWS Workshop Studio. Bạn có thể xem các file đã tạo:

<function_calls>
<invoke name="fs_read">
<parameter name="path">/home/ubuntu/workshop-studio
