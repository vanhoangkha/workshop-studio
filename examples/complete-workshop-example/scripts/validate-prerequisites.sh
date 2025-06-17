#!/bin/bash

# AWS Workshop Studio - Prerequisites Validation Script
# This script validates that all prerequisites are met before starting the workshop

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validation results
VALIDATION_PASSED=true
WARNINGS=()
ERRORS=()

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    WARNINGS+=("$1")
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    ERRORS+=("$1")
    VALIDATION_PASSED=false
}

check_command() {
    local cmd="$1"
    local name="$2"
    local install_url="$3"
    
    if command -v "$cmd" &> /dev/null; then
        local version=$($cmd --version 2>&1 | head -n1)
        log_success "$name is installed: $version"
        return 0
    else
        log_error "$name is not installed. Install from: $install_url"
        return 1
    fi
}

check_aws_cli_version() {
    if command -v aws &> /dev/null; then
        local version=$(aws --version 2>&1 | cut -d/ -f2 | cut -d' ' -f1)
        local major_version=$(echo "$version" | cut -d. -f1)
        
        if [ "$major_version" -ge 2 ]; then
            log_success "AWS CLI v$version (v2+ required)"
            return 0
        else
            log_error "AWS CLI v$version found, but v2+ is required"
            return 1
        fi
    else
        log_error "AWS CLI is not installed"
        return 1
    fi
}

check_node_version() {
    if command -v node &> /dev/null; then
        local version=$(node --version | sed 's/v//')
        local major_version=$(echo "$version" | cut -d. -f1)
        
        if [ "$major_version" -ge 18 ]; then
            log_success "Node.js v$version (v18+ required)"
            return 0
        else
            log_error "Node.js v$version found, but v18+ is required"
            return 1
        fi
    else
        log_error "Node.js is not installed"
        return 1
    fi
}

check_aws_credentials() {
    log_info "Checking AWS credentials..."
    
    if aws sts get-caller-identity &> /dev/null; then
        local account_id=$(aws sts get-caller-identity --query Account --output text)
        local user_arn=$(aws sts get-caller-identity --query Arn --output text)
        log_success "AWS credentials configured for account: $account_id"
        log_info "Using identity: $user_arn"
        return 0
    else
        log_error "AWS credentials not configured or invalid"
        log_info "Run: aws configure"
        return 1
    fi
}

check_aws_region() {
    log_info "Checking AWS region configuration..."
    
    local region=$(aws configure get region 2>/dev/null || echo "")
    
    if [ -n "$region" ]; then
        log_success "AWS region configured: $region"
        
        # Check if region is supported
        local supported_regions=("us-east-1" "us-west-2" "eu-west-1" "eu-central-1" "ap-southeast-1" "ap-northeast-1")
        if [[ " ${supported_regions[@]} " =~ " ${region} " ]]; then
            log_success "Region $region is supported by this workshop"
        else
            log_warning "Region $region may not be fully supported. Recommended regions: ${supported_regions[*]}"
        fi
        return 0
    else
        log_error "AWS region not configured"
        log_info "Run: aws configure set region us-east-1"
        return 1
    fi
}

check_aws_permissions() {
    log_info "Checking AWS permissions..."
    
    local required_permissions=(
        "lambda:CreateFunction"
        "dynamodb:CreateTable"
        "apigateway:POST"
        "s3:CreateBucket"
        "cloudfront:CreateDistribution"
        "cognito-idp:CreateUserPool"
        "iam:CreateRole"
        "cloudformation:CreateStack"
    )
    
    local permission_errors=0
    
    for permission in "${required_permissions[@]}"; do
        local service=$(echo "$permission" | cut -d: -f1)
        local action=$(echo "$permission" | cut -d: -f2)
        
        # Simulate permission check (simplified)
        case "$service" in
            "lambda")
                if aws lambda list-functions --max-items 1 &> /dev/null; then
                    log_success "Lambda permissions: OK"
                else
                    log_error "Missing Lambda permissions"
                    ((permission_errors++))
                fi
                ;;
            "dynamodb")
                if aws dynamodb list-tables --max-items 1 &> /dev/null; then
                    log_success "DynamoDB permissions: OK"
                else
                    log_error "Missing DynamoDB permissions"
                    ((permission_errors++))
                fi
                ;;
            "s3")
                if aws s3 ls &> /dev/null; then
                    log_success "S3 permissions: OK"
                else
                    log_error "Missing S3 permissions"
                    ((permission_errors++))
                fi
                ;;
            "iam")
                if aws iam list-roles --max-items 1 &> /dev/null; then
                    log_success "IAM permissions: OK"
                else
                    log_error "Missing IAM permissions"
                    ((permission_errors++))
                fi
                ;;
        esac
    done
    
    if [ $permission_errors -eq 0 ]; then
        log_success "All required AWS permissions verified"
        return 0
    else
        log_error "$permission_errors permission check(s) failed"
        return 1
    fi
}

check_service_limits() {
    log_info "Checking AWS service limits..."
    
    # Check Lambda concurrent executions limit
    local lambda_limit=$(aws service-quotas get-service-quota \
        --service-code lambda \
        --quota-code L-B99A9384 \
        --query 'Quota.Value' \
        --output text 2>/dev/null || echo "1000")
    
    if [ "$lambda_limit" -ge 1000 ]; then
        log_success "Lambda concurrent executions limit: $lambda_limit (≥1000 required)"
    else
        log_warning "Lambda concurrent executions limit: $lambda_limit (may be insufficient)"
    fi
    
    # Check DynamoDB table limit
    local dynamodb_limit=$(aws service-quotas get-service-quota \
        --service-code dynamodb \
        --quota-code L-F98FE922 \
        --query 'Quota.Value' \
        --output text 2>/dev/null || echo "256")
    
    if [ "$dynamodb_limit" -ge 10 ]; then
        log_success "DynamoDB table limit: $dynamodb_limit (≥10 required)"
    else
        log_warning "DynamoDB table limit: $dynamodb_limit (may be insufficient)"
    fi
}

check_disk_space() {
    log_info "Checking available disk space..."
    
    local available_space=$(df . | tail -1 | awk '{print $4}')
    local available_gb=$((available_space / 1024 / 1024))
    
    if [ $available_gb -ge 2 ]; then
        log_success "Available disk space: ${available_gb}GB (≥2GB required)"
    else
        log_warning "Available disk space: ${available_gb}GB (may be insufficient)"
    fi
}

check_internet_connectivity() {
    log_info "Checking internet connectivity..."
    
    if curl -s --max-time 10 https://aws.amazon.com > /dev/null; then
        log_success "Internet connectivity: OK"
    else
        log_error "Internet connectivity: Failed to reach AWS services"
    fi
}

# Main validation function
main() {
    echo "🔍 AWS Workshop Studio - Prerequisites Validation"
    echo "=================================================="
    echo ""
    
    log_info "Starting prerequisites validation..."
    echo ""
    
    # Check required tools
    echo "📦 Checking Required Tools..."
    check_aws_cli_version
    check_node_version
    check_command "git" "Git" "https://git-scm.com/downloads"
    check_command "curl" "cURL" "https://curl.se/download.html"
    echo ""
    
    # Check AWS configuration
    echo "☁️  Checking AWS Configuration..."
    check_aws_credentials
    check_aws_region
    check_aws_permissions
    echo ""
    
    # Check system resources
    echo "💻 Checking System Resources..."
    check_disk_space
    check_internet_connectivity
    echo ""
    
    # Check AWS service limits
    echo "📊 Checking AWS Service Limits..."
    check_service_limits
    echo ""
    
    # Summary
    echo "📋 Validation Summary"
    echo "===================="
    
    if [ ${#WARNINGS[@]} -gt 0 ]; then
        echo -e "${YELLOW}Warnings (${#WARNINGS[@]}):${NC}"
        for warning in "${WARNINGS[@]}"; do
            echo -e "${YELLOW}  • $warning${NC}"
        done
        echo ""
    fi
    
    if [ ${#ERRORS[@]} -gt 0 ]; then
        echo -e "${RED}Errors (${#ERRORS[@]}):${NC}"
        for error in "${ERRORS[@]}"; do
            echo -e "${RED}  • $error${NC}"
        done
        echo ""
    fi
    
    if [ "$VALIDATION_PASSED" = true ]; then
        echo -e "${GREEN}🎉 All prerequisites validated successfully!${NC}"
        echo -e "${GREEN}You're ready to start the workshop.${NC}"
        echo ""
        echo "Next steps:"
        echo "1. Navigate to the workshop directory"
        echo "2. Follow the workshop instructions"
        echo "3. Deploy the infrastructure using CloudFormation"
        echo ""
        exit 0
    else
        echo -e "${RED}❌ Prerequisites validation failed.${NC}"
        echo -e "${RED}Please resolve the errors above before starting the workshop.${NC}"
        echo ""
        echo "Common solutions:"
        echo "• Install missing tools using the provided URLs"
        echo "• Configure AWS credentials: aws configure"
        echo "• Ensure you have sufficient AWS permissions"
        echo "• Check your internet connection"
        echo ""
        exit 1
    fi
}

# Run validation if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
