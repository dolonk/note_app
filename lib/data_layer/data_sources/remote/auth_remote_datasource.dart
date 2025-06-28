import '../../model/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteData {
  final SupabaseClient client;

  AuthRemoteData(this.client);

  Future<AuthResponse> signup({required String email, required String password}) {
    return client.auth.signUp(email: email, password: password);
  }

  Future<void> saveUserProfile(UserProfile user) async {
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

  UserProfile? get currentUser {
    final supaUser = client.auth.currentUser;
    if (supaUser == null) return null;
    return UserProfile(id: supaUser.id, name: '', email: supaUser.email ?? '');
  }
}
