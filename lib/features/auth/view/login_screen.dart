import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/route/app_route_names.dart';
import 'package:provider/provider.dart';

import '../../../utils/snackbar_toast/snack_bar.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final vm = Provider.of<AuthProvider>(context, listen: false);

    final success = await vm.login(email: email, password: password);

    if (success) {
      DSnackBar.success(title: "✅ Login successful");
      context.pushReplacement(AppRouteNames.bottomNavBar);
    } else {
      DSnackBar.error(title: vm.errorMessage ?? "❌ Login failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Padding(padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12), child: Text('Login')),
            ),

            InkWell(
              onTap: () {
                context.push(AppRouteNames.signup);
              },
              child: Text("created account"),
            ),
          ],
        ),
      ),
    );
  }
}
