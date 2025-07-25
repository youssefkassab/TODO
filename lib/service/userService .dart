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
  // print(data1['accessToken']);
}

class UserService {
  final http.Client client;

  UserService({http.Client? client}) : client = client ?? http.Client();

  Future<UserItem> getUser() async {
    if (data1 == null) {
      throw Exception("User data is not loaded. Please call mainuser() first.");
    }
    final response = await client.get(
      Uri.parse("https://todo.hemex.ai/api/user"),
      headers: {"Authorization": "Bearer ${data1['accessToken']}"},
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      // print(UserItem.fromJson(data));
      return UserItem.fromJson(data);
    } else {
      print("t3");
      throw Exception("Failed to load user data ");
    }
  }

  Future<void> updatePost(UserItem UserItem) async {
    if (data1 == null) {
      throw Exception("User data is not loaded. Please call mainuser() first.");
    }
    final response = await client.put(
      Uri.parse("https://todo.hemex.ai/api/user"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${data1['accessToken']}",
      },
      body: json.encode(UserItem.toJson()),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print("update user successfully $UserItem");
    } else {
      throw Exception("Failed to update user");
    }
  }
}
