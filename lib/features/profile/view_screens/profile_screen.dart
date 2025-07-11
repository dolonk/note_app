import 'package:flutter/material.dart';
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

          return Scaffold(
            appBar: AppBar(title: const Text("👤 Profile"), centerTitle: true),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: vm.imageFile != null
                            ? FileImage(vm.imageFile!)
                            : (user.avatar != null ? NetworkImage(user.avatar!) : null) as ImageProvider?,
                        child: user.avatar == null && vm.imageFile == null
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                      IconButton(
                        onPressed: vm.pickImage,
                        icon: const Icon(Icons.edit, size: 20),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(controller: vm.nameController, decoration: const InputDecoration(labelText: 'Name')),
                  const SizedBox(height: 10),
                  TextField(controller: vm.emailController, readOnly: true, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 10),
                  TextField(controller: vm.bioController, decoration: const InputDecoration(labelText: 'Bio')),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(vm.isSaving ? "Saving..." : "Save"),
                    onPressed: vm.isSaving ? null : vm.saveProfile,
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => vm.logout(context),
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

