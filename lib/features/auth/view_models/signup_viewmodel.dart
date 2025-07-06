import 'package:flutter/material.dart';
import '../../../core/di/service_locator.dart';
import '../provider/auth_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../route/app_route_names.dart';
import '../../../data_layer/model/user_model.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';

class SignupViewModel with ChangeNotifier {
  final authProvider = sl<AuthProvider>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool get isLoading => authProvider.isLoading;

  Future<void> submit(BuildContext context) async {
    final user = UserModel(
      id: '',
      name: 'Dolon',
      email: emailController.text.trim(),
      createdAt: DateTime.now().toUtc(),
    );

    final password = passwordController.text.trim();
    final success = await authProvider.signUp(user: user, password: password);

    if (success == "email_confirm_required") {
      DSnackBar.success(title: "📩 Please check your email and confirm.");
      if (!context.mounted) return;
      context.pushReplacement(AppRouteNames.verifyEmail, extra: {'userProfile': user, 'password': password});
    } else if (success == null) {
      DSnackBar.success(title: "✅ Account created!");
      if (!context.mounted) return;
      context.pushReplacement(AppRouteNames.bottomNavBar);
    } else {
      DSnackBar.error(title: authProvider.errorMessage ?? '❌ Signup failed');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
