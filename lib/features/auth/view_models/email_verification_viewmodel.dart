import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../route/app_route_names.dart';
import '../../../core/di/service_locator.dart';
import '../../../data_layer/model/user_model.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data_layer/domain/use_cases/auth_use_case.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  final AuthUseCase _authUseCase = sl<AuthUseCase>();

  Timer? _timer;
  int _secondsLeft = 120;
  bool _canResend = false;
  bool _initialized = false;

  int get secondsLeft => _secondsLeft;
  bool get canResend => _canResend;

  void init({required BuildContext context, required UserModel userProfile, required String password}) {
    if (_initialized) return;
    _initialized = true;

    _startVerificationTimer();
    _pollEmailVerification(context, userProfile, password);
  }

  void _startVerificationTimer() {
    _secondsLeft = 120;
    _canResend = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        _canResend = true;
        timer.cancel();
      } else {
        _secondsLeft--;
      }
      notifyListeners();
    });
  }

  Future<void> _pollEmailVerification(BuildContext context, UserModel userProfile, String password) async {
    while (context.mounted) {
      await Future.delayed(const Duration(seconds: 5));

      final verified = await _authUseCase.isEmailVerified(userProfile.email!, password);
      if (verified) {
        _timer?.cancel();

        final uid = Supabase.instance.client.auth.currentUser?.id;
        if (uid != null) {
          final profile = userProfile.copyWith(id: uid);
          await _authUseCase.repository.saveUserProfile(profile);
        }

        DSnackBar.success(title: "✅ Email verified!");
        if (!context.mounted) return;
        context.pushReplacement(AppRouteNames.bottomNavBar);
        break;
      }
      debugPrint('⏳ Email not verified yet...');
    }
  }

  Future<void> resendEmail({required String email, required String password}) async {
    _canResend = false;
    _secondsLeft = 120;
    notifyListeners();

    _startVerificationTimer();
    await _authUseCase.resendVerificationEmail(email, password);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
