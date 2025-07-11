import '../../model/user_model.dart';
import '../repositories/auth/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<String?> signUp({required UserModel user, required String password}) {
    return repository.signUp(user: user, password: password);
  }

  Future<String?> login({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }

  Future<bool> isEmailVerified(String email, String password) =>
      repository.isEmailVerified(email: email, password: password);

  Future<void> resendVerificationEmail(String email, String password) =>
      repository.resendVerificationEmail(email, password);

  Future<bool> isUserAlreadyLoggedIn() => repository.isUserAlreadyLoggedIn();

  Future<UserModel?> fetchUserProfile(String userId) {
    return repository.fetchUserProfile(userId);
  }

  Future<void> logout() {
    return repository.logout();
  }

  UserModel? getCurrentUser() {
    return repository.getCurrentUser();
  }
}
