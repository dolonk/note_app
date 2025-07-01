import '../../../model/user_profile.dart';

abstract class AuthRepository {
  Future<String?> signUp({required UserModel user, required String password});

  Future<void> saveUserProfile(UserModel profile);

  Future<String?> login({required String email, required String password});

  Future<bool> isEmailVerified({required String email, required String password});

  Future<void> resendVerificationEmail(String email, String password);

  Future<bool> isUserAlreadyLoggedIn();

  Future<void> logout();

  UserModel? getCurrentUser();
}
