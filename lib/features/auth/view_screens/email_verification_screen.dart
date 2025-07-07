import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data_layer/model/user_model.dart';
import 'package:note_app/features/auth/view_models/email_verification_viewmodel.dart';

class EmailVerificationScreen extends StatelessWidget {
  final UserModel userProfile;
  final String password;

  const EmailVerificationScreen({super.key, required this.userProfile, required this.password});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = EmailVerificationViewModel();
        vm.init(context: context, userProfile: userProfile, password: password);
        return vm;
      },
      child: Consumer<EmailVerificationViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(title: const Text("Verify Your Email")),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("📩 A verification email has been sent to:\n${userProfile.email}"),
                  const SizedBox(height: 30),
                  vm.canResend
                      ? ElevatedButton(
                        onPressed: () => vm.resendEmail(email: userProfile.email!, password: password),
                        child: const Text("Resend Email"),
                      )
                      : Text("⏳ You can resend in ${vm.secondsLeft} seconds"),
                  const SizedBox(height: 24),
                  const Text("Once verified, you’ll be redirected automatically."),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
