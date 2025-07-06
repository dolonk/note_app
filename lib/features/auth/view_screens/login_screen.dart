import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../view_models/login_viewmodel.dart';
import 'package:note_app/route/app_route_names.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: vm.emailController,
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: vm.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  vm.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: () => vm.login(context),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          child: Text('Login'),
                        ),
                      ),
                  const SizedBox(height: 16),
                  InkWell(onTap: () => context.push(AppRouteNames.signup), child: const Text("Create Account")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
