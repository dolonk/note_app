import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data_layer/data_sources/remote/auth_remote_datasource.dart';
import '../../../data_layer/model/user_profile.dart';
import '../../../route/app_route_names.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';
import 'package:note_app/features/auth/provider/email_verification_provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String name;
  final String email;

  const EmailVerificationScreen({super.key, required this.name, required this.email});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late final EmailVerificationProvider vm;

  @override
  void initState() {
    super.initState();
    vm = Provider.of<EmailVerificationProvider>(context, listen: false);
    vm.startTimer();
    _pollEmailVerification();
  }

  void _pollEmailVerification() async {
    while (mounted) {
      final verified = await vm.isEmailVerified();
      if (verified) {
        vm.disposeTimer();

        final uid = Supabase.instance.client.auth.currentUser?.id;
        if (uid != null) {
          final profile = UserProfile(
            id: uid,
            name: widget.name,
            email: widget.email,
            createdAt: DateTime.now().toUtc(),
          );

          await vm._authUseCase.saveUserProfile(profile);
        }

        if (!mounted) return;
        DSnackBar.success(title: "✅ Email verified!");
        Navigator.pushReplacementNamed(context, AppRouteNames.dashboard);
        return;
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  void dispose() {
    vm.disposeTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<EmailVerificationProvider>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Verify Your Email")),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text("📩 A verification email has been sent to:\n${widget.email}", textAlign: TextAlign.center),
                  const SizedBox(height: 30),
                  model.canResend
                      ? ElevatedButton(
                        onPressed: () async {
                          try {
                            await model.resendEmail(widget.email);
                            DSnackBar.success(title: "📩 Verification email resent");
                          } catch (_) {
                            DSnackBar.error(title: "❌ Failed to resend");
                          }
                        },
                        child: const Text("Resend Email"),
                      )
                      : Text("⏳ You can resend in ${model.secondsLeft} seconds"),
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
