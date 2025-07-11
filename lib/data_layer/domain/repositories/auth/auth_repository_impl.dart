import 'auth_repository.dart';
import 'package:flutter/material.dart';
import '../../../model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data_sources/remote/auth_remote_datasource.dart';
import '../../../../utils/exceptions/supabase_exception_handler.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteData remoteData;

  AuthRepositoryImpl(this.remoteData);

  @override
  Future<String?> signUp({required UserModel user, required String password}) async {
    try {
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
    } catch (e) {
      return SupabaseExceptionHandler.parse(e);
    }
  }

  @override
  Future<String?> login({required String email, required String password}) async {
    try {
      final response = await remoteData.login(email: email, password: password);

      if (response.user == null) {
        return "Login failed";
      }

      return null;
    } catch (e) {
      return SupabaseExceptionHandler.parse(e);
    }
  }

  @override
  Future<bool> isEmailVerified({required String email, required String password}) async {
    try {
      final result = await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);
      final user = result.user;
      return user?.emailConfirmedAt != null;
    } catch (e) {
      debugPrint("Email verification check failed: $e");
      return false;
    }
  }

  @override
  Future<void> resendVerificationEmail(String email, String password) async {
    try {
      await remoteData.signup(email: email, password: password);
    } catch (e) {
      SupabaseExceptionHandler.parse(e);
    }
  }

  @override
  Future<void> saveUserProfile(UserModel profile) async {
    try {
      await remoteData.saveUserProfile(profile);
    } catch (e) {
      SupabaseExceptionHandler.parse(e);
    }
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
      SupabaseExceptionHandler.parse(e);
      return false;
    }
  }

  @override
  Future<UserModel?> fetchUserProfile(String userId) async {
    try {
      return await remoteData.fetchUserProfile(userId);
    } catch (e) {
      SupabaseExceptionHandler.parse(e);
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteData.logout();
    } catch (e) {
      SupabaseExceptionHandler.parse(e);
    }
  }

  @override
  UserModel? getCurrentUser() {
    return remoteData.currentUser;
  }
}
