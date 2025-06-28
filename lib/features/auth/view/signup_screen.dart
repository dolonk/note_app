import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../route/app_route_names.dart';
import '../../../data_layer/model/user_profile.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';
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

    final user = UserProfile(
      id: '',
      name: 'Dolon',
      email: emailController.text.trim(),
      createdAt: DateTime.now().toUtc(),
    );

    final success = await vm.signUp(user: user, password: passwordController.text.trim());

    if (success == "email_confirm_required") {
      DSnackBar.success(title: "📩 Please check your email and confirm.");
      Navigator.pushReplacementNamed(context, AppRouteNames.verifyEmail);
    } else if (success == null) {
      DSnackBar.success(title: "✅ Account created!");
      Navigator.pushReplacementNamed(context, AppRouteNames.dashboard);
    } else {
      DSnackBar.error(title: vm.errorMessage ?? '❌ Signup failed');
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
