import 'auth_repository.dart';
import 'package:flutter/material.dart';
import '../../../model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data_sources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteData remoteData;

  AuthRepositoryImpl(this.remoteData);

  @override
  Future<String?> signUp({required UserModel user, required String password}) async {
    final response = await remoteData.signup(email: user.email!, password: password);

    final supaUser = response.user;
    final session = response.session;

    if (session == null) {
      return "email_confirm_required";
    }

    if (supaUser == null) {
      return "Signup failed";
    }

    // Save profile to DB
    final profile = UserModel(
      id: supaUser.id,
      name: user.name,
      email: user.email,
      bio: user.bio,
      avatar: user.avatar,
      role: user.role,
      createdAt: DateTime.now().toUtc(),
    );
    await remoteData.saveUserProfile(profile);

    return null;
  }

  @override
  Future<void> saveUserProfile(UserModel profile) {
    return remoteData.saveUserProfile(profile);
  }

  @override
  Future<String?> login({required String email, required String password}) async {
    final response = await remoteData.login(email: email, password: password);

    if (response.user == null) {
      return "Login failed";
    }

    return null;
  }

  @override
  Future<bool> isEmailVerified({required String email, required String password}) async {
    try {
      final result = await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);
      final user = result.user;
      return user?.emailConfirmedAt != null;
    } catch (e) {
      debugPrint("Login check for email verification failed: $e");
      return false;
    }
  }

  @override
  Future<void> resendVerificationEmail(String email, String password) {
    return remoteData.signup(email: email, password: password);
  }

  @override
  Future<bool> isUserAlreadyLoggedIn() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return false;

      await Supabase.instance.client.auth.refreshSession();
      final updatedUser = Supabase.instance.client.auth.currentUser;

      return updatedUser?.emailConfirmedAt != null;
    } catch (e) {
      debugPrint('🔁 Login check failed: $e');
      return false;
    }
  }

  @override
  Future<void> logout() => remoteData.logout();

  @override
  UserModel? getCurrentUser() {
    return remoteData.currentUser;
  }
}
