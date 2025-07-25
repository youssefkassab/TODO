import 'package:flutter/material.dart';
import '../service/auth.dart';
import '../screens/HomeScreen.dart';
var emailController = TextEditingController();
var passwordController = TextEditingController();
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}
class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: Container(
     padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text("Signup", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              obscureText: false,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Color(0xFFb3e5fc)),
                filled: true,
                fillColor: const Color(0xFF2c5364),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF00c6ff)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0072ff), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Color(0xFFb3e5fc)),
                filled: true,
                fillColor: const Color(0xFF2c5364),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF00c6ff)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0072ff), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async{
                print("starting signup");
                final authService = Auth();
                final response = await authService.signup(
                  emailController.text,
                  passwordController.text,
                );
if (response != null) {
                Navigator.pushReplacement<void ,void>(context, MaterialPageRoute(builder:(BuildContext context) => const HomeScreen()));
                setState(() {});
}
              },
              child: const Text('Signup'),
            ),

        ]),
      ),);
  }
}