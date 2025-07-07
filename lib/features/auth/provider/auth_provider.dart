import 'package:flutter/material.dart';
import '../../../core/di/service_locator.dart';
import '../../../data_layer/model/user_model.dart';
import '../../../data_layer/domain/use_cases/auth_use_case.dart';

class AuthProvider with ChangeNotifier {
  final AuthUseCase _authUseCase = sl<AuthUseCase>();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> signUp({required UserModel user, required String password}) async {
    _setLoading(true);
    try {
      final result = await _authUseCase.signUp(user: user, password: password);
      _errorMessage = result;
      return result;
    } catch (e) {
      _errorMessage = "Signup failed: ${e.toString()}";
      return _errorMessage;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    try {
      final result = await _authUseCase.login(email: email, password: password);
      final isSuccess = result == null;
      _errorMessage = isSuccess ? null : result;
      return isSuccess;
    } catch (e) {
      _errorMessage = "Login failed: ${e.toString()}";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> isEmailVerified(String email, String password) async {
    try {
      return await _authUseCase.isEmailVerified(email, password);
    } catch (e, stack) {
      debugPrint("❌ isEmailVerified error: $e\n$stack");
      _errorMessage = e.toString();
      return false;
    }
  }

  Future<void> saveUserProfile(UserModel profile) async {
    try {
      await _authUseCase.repository.saveUserProfile(profile);
    } catch (e, stack) {
      debugPrint("❌ saveUserProfile error: $e\n$stack");
      _errorMessage = e.toString();
    }
  }

  Future<void> resendEmail({required String email, required String password}) async {
    try {
      await _authUseCase.resendVerificationEmail(email, password);
    } catch (e, stack) {
      debugPrint("❌ resendEmail error: $e\n$stack");
      _errorMessage = e.toString();
    }
  }

  Future<void> logout() async {
    try {
      await _authUseCase.logout();
      notifyListeners();
    } catch (e, stack) {
      debugPrint("❌ logout error: $e\n$stack");
      _errorMessage = e.toString();
    }
  }
}
