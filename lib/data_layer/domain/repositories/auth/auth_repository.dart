import '../../../model/user_profile.dart';

abstract class AuthRepository {
  Future<String?> signUp({required UserProfile user, required String password});

  Future<void> saveUserProfile(UserProfile profile);

  Future<String?> login({required String email, required String password});

  Future<bool> isEmailVerified({required String email, required String password});

  Future<void> resendVerificationEmail(String email, String password);

  Future<bool> isUserAlreadyLoggedIn();

  Future<void> logout();

  UserProfile? getCurrentUser();
}
