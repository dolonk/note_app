import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/service_locator.dart';
import '../../../data_layer/domain/use_cases/auth_use_case.dart';
import '../../../data_layer/model/user_profile.dart';
import '../../../route/app_route_names.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';

class EmailVerificationProvider with ChangeNotifier {
  final AuthUseCase _authUseCase = sl<AuthUseCase>();

  Timer? _timer;
  int _secondsLeft = 120;
  bool _canResend = false;

  int get secondsLeft => _secondsLeft;
  bool get canResend => _canResend;

  void startTimer() {
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

  Future<void> resendEmail({required String email, required String password}) async {
    _canResend = false;
    _secondsLeft = 120;
    notifyListeners();

    startTimer();

    await _authUseCase.resendVerificationEmail(email, password);
  }

  Future<bool> isEmailVerified(String email, String password) async {
    return _authUseCase.isEmailVerified(email, password);
  }

  Future<void> saveUserProfile(UserModel profile) async {
    await _authUseCase.repository.saveUserProfile(profile);
  }

  void disposeTimer() {
    _timer?.cancel();
  }
}
