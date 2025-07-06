import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../route/app_route_names.dart';
import '../../../data_layer/model/user_model.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';
import '../provider/email_verification_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  EmailVerificationProvider? _emailProvider;
  bool _initialized = false;

  void updateEmailProvider(
    EmailVerificationProvider emailProvider,
    BuildContext context,
    UserModel userProfile,
    String password,
  ) {
    if (!_initialized) {
      _emailProvider = emailProvider;
      _initialized = true;

      _emailProvider!.startTimer();
      _pollEmailVerification(context, userProfile, password);
    }
  }

  Future<void> _pollEmailVerification(BuildContext context, UserModel userProfile, String password) async {
    while (context.mounted) {
      final verified = await _emailProvider!.isEmailVerified(userProfile.email!, password);
      if (verified) {
        _emailProvider!.disposeTimer();

        final uid = Supabase.instance.client.auth.currentUser?.id;
        if (uid != null) {
          final profile = userProfile.copyWith(id: uid);
          await _emailProvider!.saveUserProfile(profile);
        }

        if (!context.mounted) return;
        DSnackBar.success(title: "✅ Email verified!");
        context.pushReplacement(AppRouteNames.bottomNavBar);
        return;
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  void dispose() {
    _emailProvider?.disposeTimer();
    super.dispose();
  }
}
