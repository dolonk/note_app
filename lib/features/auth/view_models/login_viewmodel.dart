import 'package:flutter/material.dart';
import '../provider/auth_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../route/app_route_names.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';

class LoginViewModel with ChangeNotifier {
  final AuthProvider _authProvider = sl<AuthProvider>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final success = await _authProvider.login(email: email, password: password);

    if (!context.mounted) return;

    if (success) {
      DSnackBar.success(title: "✅ Login successful");
      context.pushReplacement(AppRouteNames.bottomNavBar);
    } else {
      DSnackBar.error(title: _authProvider.errorMessage ?? "❌ Login failed");
    }
  }

  @override
  void dispose() {
    print('call dispose');
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
