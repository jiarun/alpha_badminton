import 'package:flutter/material.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'dart:convert';

class AuthenticationService with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _currentUser;

  // Getter for current user
  User? get currentUser => _currentUser;

  Future<Map<String, dynamic>> login(String mobileNumber, String password) async {
    try {
      print('Attempting login with mobile: $mobileNumber');

      // Validate input
      if (mobileNumber.isEmpty || password.isEmpty) {
        print('Login failed: Mobile or password is empty');
        return {'success': false, 'error': 'Mobile or password is empty'};
      }

      final response = await _apiService.postData('login', {'mobile': mobileNumber, 'password': password});
      print('Login response: $response');

      if (response['success']) {
        _currentUser = User.fromJson(response['user']);
        notifyListeners();
        return {'success': true, 'user': _currentUser};
      } else {
        String errorMsg = response['error'] ?? 'Unknown error';
        print('Login failed: $errorMsg');
        return {'success': false, 'error': errorMsg};
      }
    } catch (e) {
      print('Login error: ${e.toString()}');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<bool> register(String mobileNumber, String password, {String? name, String? profilePicture}) async {
    try {
      final response = await _apiService.postData('register', {
        'mobile': mobileNumber, 
        'password': password,
        'name': name,
        'profile_picture': profilePicture
      });
      return response['success'];
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> forgotPassword(String mobileNumber) async {
    try {
      final response = await _apiService.postData('forgot-password', {'mobile': mobileNumber});
      return response['success'];
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
