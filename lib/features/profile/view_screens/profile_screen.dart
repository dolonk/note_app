import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/route/app_route_names.dart';
import 'package:provider/provider.dart';
import '../view_model/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = ProfileViewModel();
        vm.loadUser();
        return vm;
      },
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          final user = vm.user;

          if (user == null) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          final nameCtrl = TextEditingController(text: user.name);
          final emailCtrl = TextEditingController(text: user.email);
          final bioCtrl = TextEditingController(text: user.bio);

          return Scaffold(
            appBar: AppBar(title: const Text("👤 Profile"), centerTitle: true),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 20),
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 10),
                  TextField(controller: bioCtrl, decoration: const InputDecoration(labelText: 'Bio')),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(vm.isSaving ? "Saving..." : "Save"),
                    onPressed:
                        vm.isSaving
                            ? null
                            : () {
                              final updatedUser = user.copyWith(
                                name: nameCtrl.text.trim(),
                                bio: bioCtrl.text.trim(),
                              );
                              vm.saveProfile(updatedUser);
                            },
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      vm.logout();
                      context.pushReplacement(AppRouteNames.login);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
