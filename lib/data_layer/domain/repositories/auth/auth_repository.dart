import '../../../model/user_profile.dart';

abstract class AuthRepository {
  Future<String?> signUp({required UserProfile user, required String password});

  Future<void> saveUserProfile(UserProfile profile);

  Future<String?> login({required String email, required String password});

  Future<bool> isEmailVerified();

  Future<void> resendVerificationEmail(String email);

  Future<void> logout();

  UserProfile? getCurrentUser();
}
