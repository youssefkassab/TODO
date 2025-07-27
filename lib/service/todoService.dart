import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/todoitem.dart';

String token ="" ;
Future<void> main1() async {
  debugPrint("get token");
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString('accessToken')!;
}


class TodoService {

  final http.Client client;

  TodoService({http.Client? client})
      : client = client ?? http.Client();

  Future<List<TodoItem>> getTodos() async {
    // Ensure token is loaded from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? currentToken = prefs.getString('accessToken');
    
    if (currentToken == null || currentToken.isEmpty) {
      throw Exception("No valid token found. Please login again.");
    }
    
    final response = await client.get(
        Uri.parse("https://todo.hemex.ai/api/todo"),
        headers: {"Authorization": "Bearer $currentToken"},);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => TodoItem.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load posts ");
    }
  }
  Future<void> updatePost(TodoItem todoItem) async {
    // Ensure token is loaded from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? currentToken = prefs.getString('accessToken');
    
    if (currentToken == null || currentToken.isEmpty) {
      throw Exception("No valid token found. Please login again.");
    }
    
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $currentToken',
    };
    
    final body = json.encode({
      'title': todoItem.title,
      'description': todoItem.description,
    });
    
    debugPrint('Sending update request for todo ID: ${todoItem.id}');
    debugPrint('Request body: $body');
    
    // First try with PUT
    try {
      debugPrint('Trying PUT request...');
      final response = await client.put(
        Uri.parse("https://todo.hemex.ai/api/todo/${todoItem.id}"),
        headers: headers,
        body: body,
      );
      
      debugPrint("PUT response status: ${response.statusCode}");
      debugPrint("PUT response body: ${response.body}");
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Successfully updated todo using PUT: $todoItem");
        return;
      }
    } catch (e) {
      debugPrint('PUT request failed: $e');
    }
    
    // If PUT fails, try with PATCH
    try {
      debugPrint('Trying PATCH request...');
      final response = await client.patch(
        Uri.parse("https://todo.hemex.ai/api/todo/${todoItem.id}"),
        headers: headers,
        body: body,
      );
      
      debugPrint("PATCH response status: ${response.statusCode}");
      debugPrint("PATCH response body: ${response.body}");
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Successfully updated todo using PATCH: $todoItem");
        return;
      } else {
        throw Exception("Failed to update todo. Status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      debugPrint('PATCH request failed: $e');
      rethrow;
    }
  }
  Future<void> creatPost(TodoItem TodoItem) async {
    // Ensure token is loaded from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? currentToken = prefs.getString('accessToken');
    
    if (currentToken == null || currentToken.isEmpty) {
      throw Exception("No valid token found. Please login again.");
    }
    
    final response = await client.post(
      Uri.parse("https://todo.hemex.ai/api/todo"),
      headers: {"Content-Type": "application/json","Authorization": "Bearer $currentToken"},
      body: json.encode(TodoItem.toJson()),);
    debugPrint("creating post"+response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {

      debugPrint("created post successfully ");
    } else {
      throw Exception("Failed to create post");
    }
  }
  Future<void> deletePosts(int id) async {
    // Ensure token is loaded from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? currentToken = prefs.getString('accessToken');
    
    if (currentToken == null || currentToken.isEmpty) {
      throw Exception("No valid token found. Please login again.");
    }
    
    final response = await client.delete(
        Uri.parse("https://todo.hemex.ai/api/todo/$id"),
      headers: {"Content-Type": "application/json","Authorization": "Bearer $currentToken"},);
      debugPrint("deleted post successfully");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint("deleted post successfully");

    } else {
      throw Exception("Failed to delete posts");
    }
  }
// try
// catch
}