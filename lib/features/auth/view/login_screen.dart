
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Signup Screen
            Navigator.pushNamed(context, '/signup');
          },
          child: const Text('Go to Signup'),
        ),
      ),
    );
  }
}
