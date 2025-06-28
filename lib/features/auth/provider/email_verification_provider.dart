import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/di/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailVerificationProvider with ChangeNotifier {
  final SupabaseClient _client = sl<SupabaseClient>();

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

  Future<void> resendEmail(String email) async {
    _canResend = false;
    _secondsLeft = 120;
    notifyListeners();

    startTimer();

    await _client.auth.resend(type: OtpType.email, email: email);
  }

  Future<bool> isEmailVerified() async {
    await _client.auth.refreshSession();
    final user = _client.auth.currentUser;
    return user?.emailConfirmedAt != null;
  }

  void disposeTimer() {
    _timer?.cancel();
  }
}
