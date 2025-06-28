import '../../model/user_profile.dart';
import '../repositories/auth/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<String?> signUp({required UserProfile user, required String password}) {
    return repository.signUp(user: user, password: password);
  }

  Future<String?> login({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }

  Future<bool> isEmailVerified() => repository.isEmailVerified();

  Future<void> resendVerificationEmail(String email) => repository.resendVerificationEmail(email);

  Future<void> logout() {
    return repository.logout();
  }

  UserProfile? getCurrentUser() {
    return repository.getCurrentUser();
  }
}
