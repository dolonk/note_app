import 'package:flutter/material.dart';
import '../../../core/di/service_locator.dart';
import '../../../data_layer/model/user_profile.dart';
import '../../../data_layer/domain/use_cases/auth_use_case.dart';

class AuthProvider with ChangeNotifier {
  final AuthUseCase _authUseCase = sl<AuthUseCase>();

  bool isLoading = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<String?> signUp({required UserModel user, required String password}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _authUseCase.signUp(user: user, password: password);

      _errorMessage = result;
      return result;
    } catch (e) {
      _errorMessage = "Signup failed: ${e.toString()}";
      return _errorMessage;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _authUseCase.login(email: email, password: password);

      if (result == null) {
        _errorMessage = null;
        return true;
      } else {
        _errorMessage = result;
        return false;
      }
    } catch (e) {
      _errorMessage = "Login failed: ${e.toString()}";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
