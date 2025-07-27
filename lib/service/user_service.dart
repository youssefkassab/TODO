import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/userdata.dart';


dynamic data = {};
dynamic data1;

Future<void> mainuser() async {
  debugPrint("get user data");
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
          debugPrint("Error fetching user data. Status code: ${response.statusCode}");
        throw Exception("Failed to load user data");
      }
    } catch (e) {
      debugPrint("Error in getUser: $e");
      rethrow;
    }
  }

  Future<void> updatePost(UserItem userItem, {List<int>? imageBytes, String? imageName}) async {
    if (data1 == null) {
      throw Exception("User data is not loaded.");
    }

    try {
      final url = Uri.parse("https://todo.hemex.ai/api/user");
      final request = http.MultipartRequest('PATCH', url);
      
      // Add headers
      request.headers['Authorization'] = 'Bearer ${data1['accessToken']}';
      
      // Add text fields
      request.fields['username'] = userItem.username ?? '';
      request.fields['petName'] = userItem.petName ?? '';
      request.fields['address'] = userItem.address ?? '';
      
      // Add image file if provided
      if (imageBytes != null && imageName != null) {
        final multipartFile = http.MultipartFile.fromBytes(
          'photo',
          imageBytes,
          filename: imageName,
        );
        request.files.add(multipartFile);
      }
      
      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Update user successful: ${response.body}");
      } else {
        debugPrint("Failed to update user. Status: ${response.statusCode}");
        debugPrint("Response: ${response.body}");
        throw Exception("Failed to update user: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('Error in updatePost: $e');
      rethrow;
    }
  }
}
