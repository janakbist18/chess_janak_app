import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_provider.dart';
import '../../core/config/api_endpoints.dart';
import '../../core/websocket/socket_client.dart';

/// Backend connection health check screen
/// Use this to verify Django backend is working before testing features
class BackendConnectionTest extends ConsumerStatefulWidget {
  const BackendConnectionTest({Key? key}) : super(key: key);

  @override
  ConsumerState<BackendConnectionTest> createState() =>
      _BackendConnectionTestState();
}

class _BackendConnectionTestState extends ConsumerState<BackendConnectionTest> {
  late List<TestResult> results = [];
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    runTests();
  }

  Future<void> runTests() async {
    setState(() {
      isRunning = true;
      results = [];
    });

    // Test 1: API Root
    await testApiRoot();

    // Test 2: Health Check
    await testHealthCheck();

    // Test 3: Auth Endpoints
    await testAuthEndpoints();

    // Test 4: WebSocket
    await testWebSocket();

    setState(() {
      isRunning = false;
    });
  }

  Future<void> testApiRoot() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      // Get API root endpoint
      String baseUrl = ApiEndpoints.base;
      String rootUrl = baseUrl.replaceAll('/api', '');

      final response = await apiClient.get(rootUrl);

      addResult(
        'API Root',
        true,
        'Successfully connected to ${rootUrl}',
        response.statusCode,
      );
    } catch (e) {
      addResult(
        'API Root',
        false,
        'Failed: ${e.toString()}',
        null,
      );
    }
  }

  Future<void> testHealthCheck() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient
          .get('${ApiEndpoints.base.replaceAll('/api', '')}/health');

      addResult(
        'Health Check',
        true,
        'Server health: ${response.data['status'] ?? 'unknown'}',
        response.statusCode,
      );
    } catch (e) {
      addResult(
        'Health Check',
        false,
        'Failed: ${e.toString()}',
        null,
      );
    }
  }

  Future<void> testAuthEndpoints() async {
    try {
      final apiClient = ref.read(apiClientProvider);

      // Try to get auth root (no auth required)
      final response = await apiClient.get('${ApiEndpoints.base}/auth/');

      addResult(
        'Auth Endpoints',
        true,
        'Auth endpoints accessible',
        response.statusCode,
      );
    } catch (e) {
      addResult(
        'Auth Endpoints',
        false,
        'Failed: ${e.toString()}',
        null,
      );
    }
  }

  Future<void> testWebSocket() async {
    try {
      final socketClient = ref.read(socketClientProvider);

      // Note: WebSocket connection might fail if not authenticated
      // This is expected - we're just testing if connection attempt works
      final testUrl = '${ApiEndpoints.wsBase}/ws/test/';

      socketClient.on((message) {
        print('WebSocket message: ${message.type}');
      });

      // Try to connect (timeout after 5 seconds)
      socketClient.connect(testUrl).timeout(
        Duration(seconds: 5),
        onTimeout: () async {
          addResult(
            'WebSocket',
            false,
            'Connection timeout (expected for invalid path)',
            null,
          );
        },
      ).then((_) {
        addResult(
          'WebSocket',
          true,
          'WebSocket connection established',
          null,
        );
        socketClient.disconnect();
      }).catchError((e) {
        // WebSocket might fail because of invalid path, that's ok
        addResult(
          'WebSocket',
          false,
          'WebSocket error (might be expected): ${e.toString()}',
          null,
        );
      });

      // Give it some time
      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      addResult(
        'WebSocket',
        false,
        'WebSocket test error: ${e.toString()}',
        null,
      );
    }
  }

  void addResult(
    String test,
    bool success,
    String message,
    int? statusCode,
  ) {
    setState(() {
      results.add(TestResult(
        test: test,
        success: success,
        message: message,
        statusCode: statusCode,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backend Connection Test'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicator
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isRunning
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isRunning ? 'Testing...' : 'Test Complete',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isRunning ? Colors.blue : Colors.green,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${results.length} tests completed',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  if (!isRunning)
                    ElevatedButton.icon(
                      onPressed: runTests,
                      icon: Icon(Icons.refresh),
                      label: Text('Retry'),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Results
            if (results.isEmpty && isRunning)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Running tests...'),
                  ],
                ),
              )
            else
              ...results.map((result) => _buildTestResultCard(result)),

            SizedBox(height: 24),

            // Summary
            if (!isRunning && results.isNotEmpty) ...[
              Text(
                'Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              _buildSummary(),
            ],

            SizedBox(height: 32),

            // Instructions
            _buildInstructions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResultCard(TestResult result) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: result.success
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: result.success ? Colors.green : Colors.red,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            result.success ? Icons.check_circle : Icons.error,
            color: result.success ? Colors.green : Colors.red,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.test,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: result.success ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  result.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
                if (result.statusCode != null) ...[
                  SizedBox(height: 4),
                  Text(
                    'Status: ${result.statusCode}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final successCount = results.where((r) => r.success).length;
    final totalCount = results.length;
    final percentage = ((successCount / totalCount) * 100).toStringAsFixed(0);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$successCount / $totalCount tests passed ($percentage%)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (successCount == totalCount)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '✅ Backend connection is working!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else if (successCount > 0)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '⚠️ Some tests failed. Check backend logs.',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '❌ Backend connection failed. Ensure Django is running.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📋 Instructions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Start Django backend:\n'
            '   python manage.py runserver 0.0.0.0:8000\n\n'
            '2. Check Django is running at:\n'
            '   http://localhost:8000/api/\n\n'
            '3. For physical device, update lib/core/config/env.dart\n'
            '   with your local IP instead of 10.0.2.2\n\n'
            '4. After all tests pass, you can test login/register',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class TestResult {
  final String test;
  final bool success;
  final String message;
  final int? statusCode;

  TestResult({
    required this.test,
    required this.success,
    required this.message,
    this.statusCode,
  });
}
