import 'package:flutter/material.dart';
import '../screens/login.dart';
import '../service/auth.dart';


final _formKey = GlobalKey<FormState>();
final emailController = TextEditingController();
final passwordController = TextEditingController();

class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6 || value.length > 20) {
      return 'Password must be 6-20 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Must contain at least one special character';
    }
    return null;
  }
}

class UsernameValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 4 || value.length > 20) {
      return 'Username must be 4-20 characters long';
    }
    return null;
  }
}

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Create Account",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter 4-20 characters',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: UsernameValidator.validate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter 6-20 characters with special chars',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                validator: PasswordValidator.validate,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    debugPrint("Starting signup");
                    final authService = Auth();
                    try {
                      await authService.signup(
                        emailController.text,
                        passwordController.text,
                      );
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(
                              onThemeChanged: widget.onThemeChanged,
                              isDarkMode: widget.isDarkMode,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Signup failed: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        onThemeChanged: widget.onThemeChanged,
                        isDarkMode: widget.isDarkMode,
                      ),
                    ),
                  );
                },
                child: const Text('Already have an account? Log in'),
              ),
            ],
          ),
        ),
      ),);
  }
}