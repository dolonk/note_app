import 'package:flutter/material.dart';
import 'package:note_app/features/auth/view_models/email_verification_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../route/app_route_names.dart';
import '../../../data_layer/model/user_model.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:note_app/features/auth/provider/email_verification_provider.dart';

class EmailVerificationScreen extends StatelessWidget {
  final UserModel userProfile;
  final String password;

  const EmailVerificationScreen({super.key, required this.userProfile, required this.password});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmailVerificationProvider()),
        ChangeNotifierProxyProvider<EmailVerificationProvider, EmailVerificationViewModel>(
          create: (_) => EmailVerificationViewModel(),
          update: (_, emailProvider, vm) => vm!..updateEmailProvider(emailProvider, context, userProfile, password),
        ),
      ],
      child: Consumer<EmailVerificationProvider>(
        builder: (context, emailProvider, _) {
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
                  emailProvider.canResend
                      ? ElevatedButton(
                        onPressed: () => emailProvider.resendEmail(email: userProfile.email!, password: password),
                        child: const Text("Resend Email"),
                      )
                      : Text("⏳ You can resend in ${emailProvider.secondsLeft} seconds"),
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
