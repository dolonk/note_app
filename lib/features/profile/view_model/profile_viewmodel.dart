import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/di/service_locator.dart';
import '../../../data_layer/model/user_model.dart';
import '../../auth/provider/auth_provider.dart';

class ProfileViewModel with ChangeNotifier {
  final AuthProvider _authProvider = sl<AuthProvider>();
  UserModel? _user;
  bool _isSaving = false;
  String? _error;

  UserModel? get user => _user;
  bool get isSaving => _isSaving;
  String? get error => _error;

  Future<void> loadUser() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      _user = await _authProvider.getUserProfile(userId);
      notifyListeners();
    } catch (e) {
      _error = "Failed to load user: $e";
      notifyListeners();
    }
  }

  Future<void> saveProfile(UserModel updatedUser) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _authProvider.saveUserProfile(updatedUser);
      _user = updatedUser;
    } catch (e) {
      _error = "Failed to save profile: $e";
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authProvider.logout();
  }
}
