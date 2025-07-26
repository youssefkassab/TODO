import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/userdata.dart';

dynamic data = {};
dynamic data1;

Future<void> mainuser() async {
  print("get user data");
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  data = prefs.getString('userData');
  data1 = json.decode(data);
}

class UserService {
  final http.Client client;

  UserService({http.Client? client}) : client = client ?? http.Client();

  Future<UserItem> getUser() async {
    if (data1 == null) {
      throw Exception("User data is not loaded.");
    }
    
    try {
      // Get user data from API
      final response = await client.get(
        Uri.parse("https://todo.hemex.ai/api/user"),
        headers: {"Authorization": "Bearer ${data1['accessToken']}"},
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse the response
        final Map<String, dynamic> data = json.decode(response.body);
        // Get username from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final userData = json.decode(prefs.getString('userData') ?? '{}');
        final username1 = userData['user'];
        final username = username1['username'];
        // Update the data with username from SharedPreferences if it exists there
        if (username != null) {
          data['username'] = username;
        }
        return UserItem.fromJson(data);
      } else {
        print("Error fetching user data. Status code: ${response.statusCode}");
        throw Exception("Failed to load user data");
      }
    } catch (e) {
      print("Error in getUser: $e");
      rethrow;
    }
  }

  Future<void> updatePost(UserItem userItem) async {
    if (data1 == null) {
      throw Exception("User data is not loaded.");
    }
    final response = await client.put(
      Uri.parse("https://todo.hemex.ai/api/user"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${data1['accessToken']}",
      },
      body: json.encode(userItem.toJson()),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print("update user successfully $userItem");
    } else {
      print("Failed to update user ${response.body}");
      throw Exception("Failed to update user ${response.body}");
    }
  }
}
