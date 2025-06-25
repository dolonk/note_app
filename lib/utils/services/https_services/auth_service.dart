import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient client;

  AuthService(this.client);

  Future<AuthResponse> signup({required String email, required String password}) {
    return client.auth.signUp(email: email, password: password);
  }
}
