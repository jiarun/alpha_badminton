import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  // Base URL from environment variables or fallback
  String get _baseUrl {
    // Try to get from environment variables first
    final envUrl = dotenv.env['API_BASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }

    // For development environments
    if (kDebugMode) {
      // For web, use the full URL to the Node.js server
      if (kIsWeb) {
        return 'http://localhost:3000';
      }

      // For Android emulator, use 10.0.2.2 to access host machine's localhost
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3000';
      }

      // For iOS simulator and physical devices, use localhost
      return 'http://localhost:3000';
    }

    // Default production URL (this should be overridden by environment variable)
    return 'https://your-render-app.onrender.com';
  }

  // POST request
  Future<Map<String, dynamic>> postData(String endPoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl/$endPoint');
    print('Making POST request to: $url');
    print('Request body: ${jsonEncode(body)}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to load data');
      }
    } catch (e) {
      print('API error: $e');
      rethrow;
    }
  }

  // GET request
  Future<Map<String, dynamic>> getData(String endPoint) async {
    final url = Uri.parse('$_baseUrl/$endPoint');
    print('Making GET request to: $url');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to load data');
      }
    } catch (e) {
      print('API error: $e');
      rethrow;
    }
  }

  // PUT request
  Future<Map<String, dynamic>> putData(String endPoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl/$endPoint');
    print('Making PUT request to: $url');
    print('Request body: ${jsonEncode(body)}');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to load data');
      }
    } catch (e) {
      print('API error: $e');
      rethrow;
    }
  }
}
