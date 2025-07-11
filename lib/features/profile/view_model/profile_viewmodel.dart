import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/utils/snackbar_toast/snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/di/service_locator.dart';
import '../../../data_layer/model/user_model.dart';
import '../../../route/app_route_names.dart';
import '../../auth/provider/auth_provider.dart';

class ProfileViewModel with ChangeNotifier {
  final supabase = sl<SupabaseClient>();
  final AuthProvider _authProvider = sl<AuthProvider>();
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  bool _isSaving = false;
  String? _error;
  UserModel? _user;
  File? _imageFile;

  bool get isSaving => _isSaving;
  String? get error => _error;
  UserModel? get user => _user;
  File? get imageFile => _imageFile;

  Future<void> loadUser() async {
    final userProfile = await _authProvider.fetchUserProfile(supabase.auth.currentUser!.id);
    _user = userProfile;

    if (_user != null) {
      nameController.text = _user!.name;
      emailController.text = _user!.email ?? '';
      bioController.text = _user!.bio ?? '';
    }

    notifyListeners();
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _imageFile = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> saveProfile() async {
    if (_user == null) return;

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = _user!.copyWith(
        name: nameController.text.trim(),
        bio: bioController.text.trim(),
        avatar: _imageFile?.path.toString(),
      );

      await _authProvider.saveUserProfile(updatedUser);
      _user = updatedUser;
      DSnackBar.success(title: "Profile Updated", message: "Your profile has been successfully updated.");
    } catch (e) {
      _error = "Failed to save profile: $e";
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await _authProvider.logout();
    if (!context.mounted) return;
    context.pushReplacement(AppRouteNames.login);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }
}
