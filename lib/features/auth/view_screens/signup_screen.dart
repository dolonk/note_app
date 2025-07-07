import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../view_models/signup_viewmodel.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignupViewModel>(
      create: (_) => SignupViewModel(),
      child: Consumer2<AuthProvider, SignupViewModel>(
        builder: (context, authVm, vm, _) {
          final vm = context.read<SignupViewModel>();
          return Scaffold(
            appBar: AppBar(title: const Text("Sign Up")),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(controller: vm.emailController, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 12),
                  TextField(
                    controller: vm.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 20),
                  authVm.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(onPressed: () => vm.submit(context), child: const Text("Create Account")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
