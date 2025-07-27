import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Auth {
  final http.Client client;
  Auth({http.Client? client}) : client = client ?? http.Client();

  // Validate token by making a request to a protected endpoint
  Future<bool> validateToken(String token) async {
    try {
      final response = await client.get(
        Uri.parse("https://todo.hemex.ai/api/todo"), // Use a protected endpoint
        headers: {"Authorization": "Bearer $token"},
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      return false;
    }
  }

  Future<String> login(String username, String password) async {
    debugPrint("AuthService ");
    final response = await client.post(
      Uri.parse("https://todo.hemex.ai/api/auth/signin"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": username, "password": password}),
    );
    debugPrint("AuthService initialized");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = json.decode(response.body);
      // Save the whole response as a JSON string
      await prefs.setString('userData', json.encode(data));
      // Optionally, also save the accessToken separately if needed
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setBool('isLoggedIn', true);
      return data['accessToken']; // Assuming the API returns a token
    } else {
      throw Exception("${jsonDecode(response.body)["message"]}");
    }
  }

  Future<String> signup(String username, String password) async {
    debugPrint("AuthService ");
    final response = await client.post(
      Uri.parse("https://todo.hemex.ai/api/auth/signup"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": username, "password": password}),
    );
    debugPrint("AuthService initialized");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Save the whole response as a JSON string
      return response.body;
    } else {
      throw Exception("${jsonDecode(response.body)["message"]}");
    }
  }

  // Log out the user by clearing all stored authentication data
  Future<void> logout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('userData');
      await prefs.setBool('isLoggedIn', false);
      // Clear any other user-related data if needed
      debugPrint('User logged out successfully');
    } catch (e) {
      debugPrint('Error during logout: $e');
      rethrow;
    }
  }
}
