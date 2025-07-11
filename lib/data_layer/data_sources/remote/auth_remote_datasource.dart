import 'dart:io';

import '../../model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteData {
  final SupabaseClient client;

  AuthRemoteData(this.client);

  Future<AuthResponse> signup({required String email, required String password}) {
    return client.auth.signUp(email: email, password: password);
  }

  Future<void> saveUserProfile(UserModel user) async {
    final bucket = 'note';
    String? avatarUrl = user.avatar;

    // 🧠 If avatar is a local file path (not a URL), upload it
    if (avatarUrl != null && !avatarUrl.startsWith('http')) {
      final file = File(avatarUrl);
      if (await file.exists()) {
        final ext = file.path.split('.').last;
        final filePath =
            'profiles/${client.auth.currentUser?.id}/note_${DateTime.now().millisecondsSinceEpoch}.$ext';

        try {
          await Supabase.instance.client.storage
              .from(bucket)
              .uploadBinary(
                filePath,
                await file.readAsBytes(),
                fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
              );

          avatarUrl = await Supabase.instance.client.storage
              .from(bucket)
              .createSignedUrl(filePath, 60 * 60); // 1 hour signed link
        } catch (e) {
          print("❌ Avatar upload failed: $e");
        }
      }
    }

    await client.from('user_profiles').upsert({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'bio': user.bio,
      'avatar': avatarUrl,
      'created_at': user.createdAt?.toUtc().toIso8601String(),
    });
  }

  Future<AuthResponse> login({required String email, required String password}) {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  Future<UserModel?> fetchUserProfile(String userId) async {
    final response = await client.from('user_profiles').select().eq('id', userId).maybeSingle();

    if (response == null) return null;
    return UserModel.fromMap(response);
  }

  Future<void> logout() => client.auth.signOut();

  UserModel? get currentUser {
    final supabaseUser = client.auth.currentUser;
    if (supabaseUser == null) return null;
    return UserModel(id: supabaseUser.id, name: '', email: supabaseUser.email ?? '');
  }
}
