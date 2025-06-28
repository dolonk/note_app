import '../../../data_layer/model/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient client;

  AuthService(this.client);

  Future<AuthResponse> signup({required String email, required String password}) {
    return client.auth.signUp(email: email, password: password);
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      await client.from('user_profiles').insert(profile.toMap());
    } catch (e) {
      throw Exception("Profile insert failed: $e");
    }
  }

  Future<AuthResponse> login({required String email, required String password}) {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> logout() => client.auth.signOut();
  User? get currentUser => client.auth.currentUser;
}
