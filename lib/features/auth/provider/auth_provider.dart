import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data_layer/model/user_profile.dart';
import '../../../utils/services/https_services/auth_service.dart';
import '../../../core/di/service_locator.dart';

class AuthProvider with ChangeNotifier {
  final _authService = sl<AuthService>();

  bool isLoading = false;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  Future<String?> signUp({required String name, required String email, required String password}) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _authService.signup(email: email, password: password);

      final user = response.user;
      final session = response.session;

      print("🧪 response.user: ${user?.id}");
      print("🧪 response.session: ${session != null ? 'exists' : 'null'}");

      // 💡 Smart switch: email confirmation on?
      if (session == null) {
        return "email_confirm_required";
      }

      // ✅ If confirmed (or toggle is off), insert profile
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid != null) {
        final profile = UserProfile(id: uid, name: name, email: email, createdAt: DateTime.now().toUtc());
        await _authService.saveUserProfile(profile);
      }

      return null;
    } catch (e) {
      print("❌ Signup Error: ${e.toString()}");
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
