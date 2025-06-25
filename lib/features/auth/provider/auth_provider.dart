import 'package:flutter/material.dart';
import '../../../utils/services/https_services/auth_service.dart';
import '../../../core/di/service_locator.dart';

class AuthProvider with ChangeNotifier {
  final _authService = sl<AuthService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> signup(String email, String password) async {
    _setLoading(true);

    try {
      final response = await _authService.signup(email: email, password: password);

      _setLoading(false);
      return response.user != null;
    } catch (e) {
      _setLoading(false);
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
