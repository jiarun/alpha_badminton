import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  // Dynamic base URL that works for both web and mobile platforms
  String get _baseUrl {
    // For web, use the full URL to the Node.js server
    if (kIsWeb) {
      return 'http://localhost:3000'; // Direct connection to the Node.js server
    }

    // For Android emulator, use 10.0.2.2 to access host machine's localhost
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }

    // For iOS simulator and physical devices, use localhost
    return 'http://localhost:3000';
  }

  // POST request
  Future<Map<String, dynamic>> postData(String endPoint, Map<String, dynamic> body) async {
    print('Making POST request to: $_baseUrl/$endPoint');
    print('Request body: ${jsonEncode(body)}');

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endPoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('API error: ${e.toString()}');
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // GET request
  Future<Map<String, dynamic>> getData(String endPoint) async {
    print('Making GET request to: $_baseUrl/$endPoint');

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$endPoint'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('API error: ${e.toString()}');
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // PUT request
  Future<Map<String, dynamic>> putData(String endPoint, Map<String, dynamic> body) async {
    print('Making PUT request to: $_baseUrl/$endPoint');
    print('Request body: ${jsonEncode(body)}');

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$endPoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('API error: ${e.toString()}');
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
