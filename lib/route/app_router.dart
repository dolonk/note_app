import 'package:note_app/features/dashboard/dashboard.dart';

import '../data_layer/model/user_profile.dart';
import '../features/auth/view/email_verification_screen.dart';
import '../features/auth/view/login_screen.dart';
import '../features/auth/view/signup_screen.dart';
import '../utils/global_context.dart';
import 'app_route_names.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRouteNames.login,
  navigatorKey: GlobalContext.navigatorKey,
  routes: [
    GoRoute(path: AppRouteNames.login, builder: (context, state) => const LoginScreen()),
    GoRoute(path: AppRouteNames.signup, builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: AppRouteNames.verifyEmail,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return EmailVerificationScreen(
          userProfile: args['userProfile'] as UserProfile,
          password: args['password'] as String,
        );
      },
    ),

    // Dashboard and Notes will be added later
    GoRoute(path: AppRouteNames.dashboard, builder: (context, state) => const Dashboard()),
  ],
);
