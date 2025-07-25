import 'package:flutter/material.dart';
import '../service/auth.dart';
import '../screens/HomeScreen.dart';
import '../screens/signup.dart';
var emailController = TextEditingController();
var passwordController = TextEditingController();
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Container(
     padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text("Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
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
              style: ButtonStyle(),
              onPressed: () async{
                print("starting login");
                final authService = Auth();
                final response = await authService.login(
                  emailController.text,
                  passwordController.text,
                );
                Navigator.pushReplacement<void ,void>(context, MaterialPageRoute(builder:(BuildContext context) => const HomeScreen()));
                setState(() {

                });
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dont have account?", style: TextStyle(color: Colors.blueAccent)),
                  ElevatedButton(onPressed: () {
                    Navigator.pushReplacement<void ,void>(context, MaterialPageRoute(builder:(BuildContext context) => const SignupScreen()));
                  }, child: const Text('Signup'),),
                ]),

        ]),
      ),);
  }
}