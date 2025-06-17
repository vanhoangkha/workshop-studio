// Jest Setup File for AWS Workshop Studio Testing
// This file runs before all tests and sets up the testing environment

// Mock AWS SDK
jest.mock('@aws-sdk/client-dynamodb');
jest.mock('@aws-sdk/lib-dynamodb');
jest.mock('@aws-sdk/client-lambda');
jest.mock('@aws-sdk/client-s3');
jest.mock('@aws-sdk/client-cloudformation');

// Global test utilities
global.testUtils = {
  // Create mock AWS Lambda event
  createLambdaEvent: (httpMethod = 'GET', path = '/', body = null, queryStringParameters = null, pathParameters = null) => {
    return {
      httpMethod,
      path,
      body: body ? JSON.stringify(body) : null,
      queryStringParameters,
      pathParameters,
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'test-agent'
      },
      requestContext: {
        requestId: 'test-request-id',
        stage: 'test',
        httpMethod,
        path,
        accountId: '123456789012',
        apiId: 'test-api-id'
      },
      isBase64Encoded: false
    };
  },

  // Create mock AWS Lambda context
  createLambdaContext: (functionName = 'test-function') => {
    return {
      functionName,
      functionVersion: '$LATEST',
      invokedFunctionArn: `arn:aws:lambda:us-east-1:123456789012:function:${functionName}`,
      memoryLimitInMB: '256',
      awsRequestId: 'test-request-id',
      logGroupName: `/aws/lambda/${functionName}`,
      logStreamName: '2024/06/17/[$LATEST]test-stream',
      getRemainingTimeInMillis: () => 30000,
      done: jest.fn(),
      fail: jest.fn(),
      succeed: jest.fn()
    };
  },

  // Create mock DynamoDB item
  createMockTask: (overrides = {}) => {
    return {
      taskId: 'task-123e4567-e89b-12d3-a456-426614174000',
      userId: 'user-123',
      title: 'Test Task',
      description: 'This is a test task',
      status: 'TODO',
      priority: 'MEDIUM',
      dueDate: '2024-07-01T10:00:00Z',
      tags: ['test'],
      createdAt: '2024-06-17T10:00:00Z',
      updatedAt: '2024-06-17T10:00:00Z',
      ...overrides
    };
  },

  // Create mock API Gateway response
  createMockApiResponse: (statusCode = 200, body = {}, headers = {}) => {
    return {
      statusCode,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        ...headers
      },
      body: JSON.stringify(body)
    };
  },

  // Wait for async operations
  wait: (ms = 100) => new Promise(resolve => setTimeout(resolve, ms)),

  // Generate random test data
  generateTestData: {
    taskId: () => `task-${Math.random().toString(36).substr(2, 9)}`,
    userId: () => `user-${Math.random().toString(36).substr(2, 9)}`,
    email: () => `test-${Math.random().toString(36).substr(2, 5)}@example.com`,
    title: () => `Test Task ${Math.random().toString(36).substr(2, 5)}`,
    description: () => `Test description ${Math.random().toString(36).substr(2, 10)}`
  }
};

// Global test constants
global.testConstants = {
  AWS_REGION: 'us-east-1',
  TABLE_NAME: 'test-tasks-table',
  API_ENDPOINT: 'https://test-api.execute-api.us-east-1.amazonaws.com/test',
  BUCKET_NAME: 'test-workshop-bucket',
  STACK_NAME: 'test-workshop-stack'
};

// Mock console methods to reduce noise in tests
const originalConsole = { ...console };
global.console = {
  ...console,
  log: jest.fn(),
  info: jest.fn(),
  warn: jest.fn(),
  error: jest.fn(),
  debug: jest.fn()
};

// Restore console for specific tests if needed
global.restoreConsole = () => {
  global.console = originalConsole;
};

// Mock environment variables
process.env.NODE_ENV = 'test';
process.env.AWS_REGION = 'us-east-1';
process.env.TABLE_NAME = 'test-tasks-table';
process.env.API_ENDPOINT = 'https://test-api.execute-api.us-east-1.amazonaws.com/test';

// Global test hooks
beforeEach(() => {
  // Clear all mocks before each test
  jest.clearAllMocks();
});

afterEach(() => {
  // Clean up after each test
  jest.restoreAllMocks();
});

// Global error handler for unhandled promises
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

// Increase timeout for integration tests
jest.setTimeout(30000);

// Custom matchers
expect.extend({
  // Check if response is valid API Gateway response
  toBeValidApiResponse(received) {
    const pass = received &&
      typeof received.statusCode === 'number' &&
      received.headers &&
      typeof received.body === 'string';

    if (pass) {
      return {
        message: () => `expected ${received} not to be a valid API Gateway response`,
        pass: true
      };
    } else {
      return {
        message: () => `expected ${received} to be a valid API Gateway response`,
        pass: false
      };
    }
  },

  // Check if response has CORS headers
  toHaveCorsHeaders(received) {
    const pass = received &&
      received.headers &&
      received.headers['Access-Control-Allow-Origin'] === '*';

    if (pass) {
      return {
        message: () => `expected ${received} not to have CORS headers`,
        pass: true
      };
    } else {
      return {
        message: () => `expected ${received} to have CORS headers`,
        pass: false
      };
    }
  },

  // Check if task object is valid
  toBeValidTask(received) {
    const requiredFields = ['taskId', 'userId', 'title', 'status', 'createdAt', 'updatedAt'];
    const pass = received &&
      typeof received === 'object' &&
      requiredFields.every(field => received.hasOwnProperty(field));

    if (pass) {
      return {
        message: () => `expected ${received} not to be a valid task object`,
        pass: true
      };
    } else {
      return {
        message: () => `expected ${received} to be a valid task object with fields: ${requiredFields.join(', ')}`,
        pass: false
      };
    }
  }
});

console.log('🧪 Test environment setup complete');
