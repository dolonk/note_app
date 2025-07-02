import '../../model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteData {
  final SupabaseClient client;

  AuthRemoteData(this.client);

  Future<AuthResponse> signup({required String email, required String password}) {
    return client.auth.signUp(email: email, password: password);
  }

  Future<void> saveUserProfile(UserModel user) async {
    await client.from('user_profiles').insert({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<AuthResponse> login({required String email, required String password}) {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> logout() => client.auth.signOut();

  UserModel? get currentUser {
    final supabaseUser = client.auth.currentUser;
    if (supabaseUser == null) return null;
    return UserModel(id: supabaseUser.id, name: '', email: supabaseUser.email ?? '');
  }
}
