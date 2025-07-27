import 'package:flutter/material.dart';
import '../service/auth.dart';
import '../screens/HomeScreen.dart';
var emailController = TextEditingController();
var passwordController = TextEditingController();
class SignupScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  
  const SignupScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });
  
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}
class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
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
              "Signup", 
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
                print("starting signup");
                final authService = Auth();
                final response = await authService.signup(
                  emailController.text,
                  passwordController.text,
                );
if (response != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      onThemeChanged: widget.onThemeChanged,
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),
                );
                setState(() {});
}
              },
              child: const Text('Signup'),
            ),

        ]),
      ),);
  }
}