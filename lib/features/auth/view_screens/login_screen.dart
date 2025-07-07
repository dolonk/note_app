import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../view_models/login_viewmodel.dart';
import 'package:note_app/route/app_route_names.dart';
import 'package:note_app/utils/default_sizes/sizes.dart';
import 'package:note_app/features/auth/provider/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
      child: Consumer2<AuthProvider, LoginViewModel>(
        builder: (context, authVm, vm, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: Padding(
              padding: const EdgeInsets.all(DSizes.defaultSpace),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(controller: vm.emailController, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: DSizes.spaceBtwItems),
                  TextField(
                    controller: vm.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: DSizes.defaultSpace),
                  authVm.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(onPressed: () => vm.login(context), child: const Text('Login')),
                  const SizedBox(height: DSizes.spaceBtwItems),
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
