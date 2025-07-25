import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
    print("AuthService ");
    final response = await client.post(
      Uri.parse("https://todo.hemex.ai/api/auth/signin"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": username, "password": password}),
    );
    print("AuthService initialized");

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
      throw Exception("Failed to login${response.body}");
    }
  }
  Future<String> signup(String username, String password) async {
    print("AuthService ");
    final response = await client.post(
      Uri.parse("https://todo.hemex.ai/api/auth/signup"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": username, "password": password}),
    );
    print("AuthService initialized");

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
      throw Exception("Failed to signup ${response.body}");
    }
  }
}
