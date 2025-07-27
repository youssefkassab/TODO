import 'package:flutter/material.dart';
import '../service/auth.dart';
import '../screens/HomeScreen.dart';
import '../screens/signup.dart';
var emailController = TextEditingController();
var passwordController = TextEditingController();
class LoginScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  
  const LoginScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              widget.onThemeChanged(!widget.isDarkMode);
            },
          ),
        ],
      ),
      body: Container(
     padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "Login", 
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
              onPressed: () async{
                print("starting login");
                final authService = Auth();
                final response = await authService.login(
                  emailController.text,
                  passwordController.text,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      onThemeChanged: widget.onThemeChanged,
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),
                );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupScreen(
                          onThemeChanged: widget.onThemeChanged,
                          isDarkMode: widget.isDarkMode,
                        ),
                      ),
                    );
                  }, child: const Text('Signup'),),
                ]),

        ]),
      ),);
  }
}