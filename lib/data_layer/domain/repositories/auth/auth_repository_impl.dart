import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_repository.dart';
import '../../../model/user_profile.dart';
import '../../../data_sources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteData remoteData;

  AuthRepositoryImpl(this.remoteData);

  @override
  Future<String?> signUp({required UserProfile user, required String password}) async {
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
    final profile = UserProfile(
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
  Future<void> saveUserProfile(UserProfile profile) {
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
  Future<bool> isEmailVerified() async {
    await Supabase.instance.client.auth.refreshSession();
    final user = Supabase.instance.client.auth.currentUser;
    return user?.emailConfirmedAt != null;
  }

  @override
  Future<void> resendVerificationEmail(String email) {
    return Supabase.instance.client.auth.resend(type: OtpType.email, email: email);
  }

  @override
  Future<void> logout() => remoteData.logout();

  @override
  UserProfile? getCurrentUser() {
    return remoteData.currentUser;
  }
}
