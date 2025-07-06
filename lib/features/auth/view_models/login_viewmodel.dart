import 'package:flutter/material.dart';
import '../../../core/di/service_locator.dart';
import '../provider/auth_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../route/app_route_names.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';

class LoginViewModel with ChangeNotifier {
  final _authProvider = sl<AuthProvider>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool get isLoading => _authProvider.isLoading;
  String? get errorMessage => _authProvider.errorMessage;

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final success = await _authProvider.login(email: email, password: password);

    if (success) {
      DSnackBar.success(title: "✅ Login successful");
      if (!context.mounted) return;
      context.pushReplacement(AppRouteNames.bottomNavBar);
    } else {
      DSnackBar.error(title: errorMessage ?? "❌ Login failed");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
