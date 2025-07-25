import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/service/auth.dart';
import 'package:todo/screens/login.dart';
import 'package:todo/screens/todo.dart';
import 'package:todo/service/todoService.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}





class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    print('checking login status');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');
    final Auth auth = Auth();
    bool valid = false;
    if (token != null && token.isNotEmpty) {
      valid = await auth.validateToken(token);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (valid) {
        print('token is valid');
        // Ensure token is loaded from SharedPreferences
        await main1();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Todo()),
        );
      } else {
        print('invalid');
        // Clear login info if token is invalid
        await prefs.setBool('isLoggedIn', false);
        await prefs.remove('accessToken');
        await prefs.remove('userData');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}




