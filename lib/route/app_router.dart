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
    GoRoute(path: AppRouteNames.verifyEmail, builder: (context, state) => const EmailVerificationScreen()),
    // Dashboard and Notes will be added later
  ],
);
