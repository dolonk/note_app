import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../route/app_route_names.dart';
import 'package:note_app/features/auth/provider/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _submit() async {
    final vm = Provider.of<AuthProvider>(context, listen: false);
    final success = await vm.signup(emailController.text.trim(), passwordController.text.trim());

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRouteNames.verifyEmail);
    } else {
      final error = vm.errorMessage ?? 'Signup failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(title: const Text("Sign Up")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 20),

                vm.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(onPressed: _submit, child: const Text("Create Account")),
              ],
            ),
          ),
        );
      },
    );
  }
}
