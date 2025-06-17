#!/bin/bash

# AWS Workshop Studio - Complete Workshop Deployment Script
# This script deploys the entire serverless web application infrastructure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
STACK_NAME="ServerlessWorkshop"
TEMPLATE_FILE="templates/main-infrastructure.yaml"
REGION=$(aws configure get region || echo "us-east-1")
ENVIRONMENT_NAME="ServerlessWorkshop"

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check if stack exists
stack_exists() {
    aws cloudformation describe-stacks --stack-name "$1" --region "$REGION" &> /dev/null
}

# Function to get stack status
get_stack_status() {
    aws cloudformation describe-stacks \
        --stack-name "$1" \
        --region "$REGION" \
        --query 'Stacks[0].StackStatus' \
        --output text 2>/dev/null || echo "NOT_FOUND"
}

# Function to wait for stack operation
wait_for_stack() {
    local stack_name="$1"
    local operation="$2"
    
    log_info "Waiting for stack $operation to complete..."
    
    case "$operation" in
        "create")
            aws cloudformation wait stack-create-complete --stack-name "$stack_name" --region "$REGION"
            ;;
        "update")
            aws cloudformation wait stack-update-complete --stack-name "$stack_name" --region "$REGION"
            ;;
        "delete")
            aws cloudformation wait stack-delete-complete --stack-name "$stack_name" --region "$REGION"
            ;;
    esac
}

# Function to get stack outputs
get_stack_outputs() {
    local stack_name="$1"
    
    log_info "Retrieving stack outputs..."
    
    aws cloudformation describe-stacks \
        --stack-name "$stack_name" \
        --region "$REGION" \
        --query 'Stacks[0].Outputs' \
        --output table
}

# Function to create or update stack
deploy_stack() {
    local stack_name="$1"
    local template_file="$2"
    
    # Validate template first
    log_info "Validating CloudFormation template..."
    if aws cloudformation validate-template --template-body "file://$template_file" --region "$REGION" > /dev/null; then
        log_success "Template validation passed"
    else
        log_error "Template validation failed"
        exit 1
    fi
    
    # Check if stack exists
    if stack_exists "$stack_name"; then
        local status=$(get_stack_status "$stack_name")
        log_info "Stack $stack_name exists with status: $status"
        
        case "$status" in
            "CREATE_COMPLETE"|"UPDATE_COMPLETE"|"UPDATE_ROLLBACK_COMPLETE")
                log_info "Updating existing stack..."
                
                # Create change set first
                local change_set_name="workshop-changeset-$(date +%s)"
                
                aws cloudformation create-change-set \
                    --stack-name "$stack_name" \
                    --template-body "file://$template_file" \
                    --change-set-name "$change_set_name" \
                    --capabilities CAPABILITY_NAMED_IAM \
                    --parameters ParameterKey=EnvironmentName,ParameterValue="$ENVIRONMENT_NAME" \
                    --region "$REGION"
                
                # Wait for change set creation
                aws cloudformation wait change-set-create-complete \
                    --stack-name "$stack_name" \
                    --change-set-name "$change_set_name" \
                    --region "$REGION"
                
                # Describe changes
                log_info "Proposed changes:"
                aws cloudformation describe-change-set \
                    --stack-name "$stack_name" \
                    --change-set-name "$change_set_name" \
                    --region "$REGION" \
                    --query 'Changes[*].[Action,ResourceChange.LogicalResourceId,ResourceChange.ResourceType]' \
                    --output table
                
                # Execute change set
                read -p "Do you want to execute these changes? (y/N): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    aws cloudformation execute-change-set \
                        --stack-name "$stack_name" \
                        --change-set-name "$change_set_name" \
                        --region "$REGION"
                    
                    wait_for_stack "$stack_name" "update"
                    log_success "Stack updated successfully"
                else
                    log_info "Update cancelled"
                    aws cloudformation delete-change-set \
                        --stack-name "$stack_name" \
                        --change-set-name "$change_set_name" \
                        --region "$REGION"
                    return 0
                fi
                ;;
            "ROLLBACK_COMPLETE"|"CREATE_FAILED")
                log_warning "Stack is in failed state. Deleting and recreating..."
                aws cloudformation delete-stack --stack-name "$stack_name" --region "$REGION"
                wait_for_stack "$stack_name" "delete"
                
                # Create new stack
                log_info "Creating new stack..."
                aws cloudformation create-stack \
                    --stack-name "$stack_name" \
                    --template-body "file://$template_file" \
                    --capabilities CAPABILITY_NAMED_IAM \
                    --parameters ParameterKey=EnvironmentName,ParameterValue="$ENVIRONMENT_NAME" \
                    --region "$REGION" \
                    --tags Key=Workshop,Value=ServerlessWebApp Key=Environment,Value=Development
                
                wait_for_stack "$stack_name" "create"
                log_success "Stack created successfully"
                ;;
            *)
                log_error "Stack is in unexpected state: $status"
                exit 1
                ;;
        esac
    else
        log_info "Creating new stack..."
        aws cloudformation create-stack \
            --stack-name "$stack_name" \
            --template-body "file://$template_file" \
            --capabilities CAPABILITY_NAMED_IAM \
            --parameters ParameterKey=EnvironmentName,ParameterValue="$ENVIRONMENT_NAME" \
            --region "$REGION" \
            --tags Key=Workshop,Value=ServerlessWebApp Key=Environment,Value=Development
        
        wait_for_stack "$stack_name" "create"
        log_success "Stack created successfully"
    fi
}

# Function to deploy sample frontend
deploy_frontend() {
    log_info "Deploying sample frontend application..."
    
    # Get S3 bucket name from stack outputs
    local bucket_name=$(aws cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --region "$REGION" \
        --query 'Stacks[0].Outputs[?OutputKey==`FrontendBucketName`].OutputValue' \
        --output text)
    
    if [ -z "$bucket_name" ]; then
        log_error "Could not retrieve S3 bucket name from stack outputs"
        return 1
    fi
    
    # Create a simple HTML file for testing
    cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Serverless Task Manager</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: white;
        }
        .container {
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.37);
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5em;
        }
        .status {
            background: rgba(255, 255, 255, 0.2);
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .success {
            border-left: 4px solid #4CAF50;
        }
        .info {
            border-left: 4px solid #2196F3;
        }
        .api-test {
            margin: 20px 0;
            padding: 20px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
        }
        button {
            background: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background: #45a049;
        }
        #result {
            margin-top: 20px;
            padding: 15px;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 5px;
            font-family: monospace;
            white-space: pre-wrap;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Serverless Task Manager</h1>
        
        <div class="status success">
            <h3>✅ Deployment Successful!</h3>
            <p>Your serverless web application has been deployed successfully.</p>
        </div>
        
        <div class="status info">
            <h3>📋 Workshop Progress</h3>
            <p><strong>Infrastructure:</strong> ✅ Complete</p>
            <p><strong>Backend API:</strong> ✅ Complete</p>
            <p><strong>Frontend:</strong> ✅ Complete</p>
            <p><strong>Authentication:</strong> 🔄 Ready for configuration</p>
        </div>
        
        <div class="api-test">
            <h3>🧪 API Test</h3>
            <p>Test your serverless backend API:</p>
            <button onclick="testAPI()">Test Create Task API</button>
            <div id="result"></div>
        </div>
        
        <div class="status info">
            <h3>🎯 Next Steps</h3>
            <ul>
                <li>Configure Cognito authentication</li>
                <li>Build the React frontend application</li>
                <li>Implement real-time features</li>
                <li>Add monitoring and logging</li>
            </ul>
        </div>
    </div>

    <script>
        // Get API Gateway URL from CloudFormation outputs
        const API_URL = 'API_GATEWAY_URL_PLACEHOLDER';
        
        async function testAPI() {
            const resultDiv = document.getElementById('result');
            resultDiv.textContent = 'Testing API...';
            
            try {
                const response = await fetch(`${API_URL}/tasks`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        userId: 'test-user-123',
                        title: 'Test Task from Frontend',
                        description: 'This task was created from the deployed frontend',
                        priority: 'HIGH',
                        status: 'TODO'
                    })
                });
                
                const data = await response.json();
                resultDiv.textContent = JSON.stringify(data, null, 2);
                
                if (data.success) {
                    resultDiv.style.borderLeft = '4px solid #4CAF50';
                } else {
                    resultDiv.style.borderLeft = '4px solid #f44336';
                }
            } catch (error) {
                resultDiv.textContent = `Error: ${error.message}`;
                resultDiv.style.borderLeft = '4px solid #f44336';
            }
        }
    </script>
</body>
</html>
EOF
    
    # Get API Gateway URL and replace placeholder
    local api_url=$(aws cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --region "$REGION" \
        --query 'Stacks[0].Outputs[?OutputKey==`ApiGatewayUrl`].OutputValue' \
        --output text)
    
    sed -i "s|API_GATEWAY_URL_PLACEHOLDER|$api_url|g" index.html
    
    # Upload to S3
    aws s3 cp index.html "s3://$bucket_name/" --region "$REGION"
    
    # Create error page
    cat > error.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Page Not Found</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        h1 { color: #333; }
    </style>
</head>
<body>
    <h1>404 - Page Not Found</h1>
    <p>The page you're looking for doesn't exist.</p>
    <a href="/">Go back to home</a>
</body>
</html>
EOF
    
    aws s3 cp error.html "s3://$bucket_name/" --region "$REGION"
    
    # Clean up temporary files
    rm -f index.html error.html
    
    log_success "Frontend deployed to S3 bucket: $bucket_name"
}

# Function to invalidate CloudFront cache
invalidate_cloudfront() {
    log_info "Invalidating CloudFront cache..."
    
    local distribution_id=$(aws cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --region "$REGION" \
        --query 'Stacks[0].Outputs[?OutputKey==`CloudFrontDistributionId`].OutputValue' \
        --output text)
    
    if [ -n "$distribution_id" ]; then
        aws cloudfront create-invalidation \
            --distribution-id "$distribution_id" \
            --paths "/*" \
            --region "$REGION" > /dev/null
        
        log_success "CloudFront invalidation created"
    else
        log_warning "Could not retrieve CloudFront distribution ID"
    fi
}

# Function to run post-deployment tests
run_tests() {
    log_info "Running post-deployment tests..."
    
    # Test API Gateway endpoint
    local api_url=$(aws cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --region "$REGION" \
        --query 'Stacks[0].Outputs[?OutputKey==`ApiGatewayUrl`].OutputValue' \
        --output text)
    
    if [ -n "$api_url" ]; then
        log_info "Testing API endpoint: $api_url"
        
        # Test POST /tasks
        local response=$(curl -s -X POST "$api_url/tasks" \
            -H "Content-Type: application/json" \
            -d '{
                "userId": "test-user-deployment",
                "title": "Deployment Test Task",
                "description": "This task was created during deployment testing",
                "priority": "MEDIUM"
            }')
        
        if echo "$response" | grep -q '"success":true'; then
            log_success "API test passed"
        else
            log_warning "API test failed: $response"
        fi
    else
        log_warning "Could not retrieve API Gateway URL for testing"
    fi
    
    # Test frontend URL
    local app_url=$(aws cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --region "$REGION" \
        --query 'Stacks[0].Outputs[?OutputKey==`ApplicationUrl`].OutputValue' \
        --output text)
    
    if [ -n "$app_url" ]; then
        log_info "Testing frontend URL: $app_url"
        
        if curl -s --max-time 10 "$app_url" > /dev/null; then
            log_success "Frontend test passed"
        else
            log_warning "Frontend test failed - may take a few minutes for CloudFront to propagate"
        fi
    fi
}

# Function to display deployment summary
show_summary() {
    echo ""
    echo "🎉 Deployment Summary"
    echo "===================="
    echo ""
    
    log_success "Infrastructure deployed successfully!"
    echo ""
    
    log_info "Stack Details:"
    echo "  Stack Name: $STACK_NAME"
    echo "  Region: $REGION"
    echo "  Environment: $ENVIRONMENT_NAME"
    echo ""
    
    log_info "Application URLs:"
    get_stack_outputs "$STACK_NAME" | grep -E "(ApplicationUrl|ApiGatewayUrl|CloudFrontUrl)"
    echo ""
    
    log_info "Next Steps:"
    echo "  1. Open the Application URL in your browser"
    echo "  2. Test the API functionality"
    echo "  3. Continue with the workshop modules"
    echo "  4. Configure Cognito authentication"
    echo ""
    
    log_info "Useful Commands:"
    echo "  View stack: aws cloudformation describe-stacks --stack-name $STACK_NAME"
    echo "  Delete stack: aws cloudformation delete-stack --stack-name $STACK_NAME"
    echo "  View logs: aws logs tail /aws/lambda/$ENVIRONMENT_NAME-CreateTask --follow"
    echo ""
}

# Main deployment function
main() {
    echo "🚀 AWS Workshop Studio - Complete Deployment"
    echo "============================================="
    echo ""
    
    # Check if we're in the right directory
    if [ ! -f "$TEMPLATE_FILE" ]; then
        log_error "CloudFormation template not found: $TEMPLATE_FILE"
        log_info "Please run this script from the workshop root directory"
        exit 1
    fi
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --stack-name)
                STACK_NAME="$2"
                shift 2
                ;;
            --region)
                REGION="$2"
                shift 2
                ;;
            --environment)
                ENVIRONMENT_NAME="$2"
                shift 2
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --stack-name NAME     CloudFormation stack name (default: ServerlessWorkshop)"
                echo "  --region REGION       AWS region (default: from AWS CLI config)"
                echo "  --environment NAME    Environment name (default: ServerlessWorkshop)"
                echo "  --help               Show this help message"
                echo ""
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    log_info "Starting deployment with the following configuration:"
    echo "  Stack Name: $STACK_NAME"
    echo "  Region: $REGION"
    echo "  Environment: $ENVIRONMENT_NAME"
    echo ""
    
    # Deploy infrastructure
    deploy_stack "$STACK_NAME" "$TEMPLATE_FILE"
    
    # Deploy frontend
    deploy_frontend
    
    # Invalidate CloudFront cache
    invalidate_cloudfront
    
    # Run tests
    run_tests
    
    # Show summary
    show_summary
    
    log_success "Deployment completed successfully! 🎉"
}

# Run deployment if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
