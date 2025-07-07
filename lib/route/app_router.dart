import '../core/di/service_locator.dart';
import '../data_layer/domain/use_cases/auth_use_case.dart';
import '../data_layer/model/user_model.dart';
import '../features/auth/view_screens/email_verification_screen.dart';
import '../features/auth/view_screens/login_screen.dart';
import '../features/auth/view_screens/signup_screen.dart';
import '../features/note/view_screens/crated_note_screen.dart';
import '../features/note/view_screens/dashboard_screen.dart';
import '../utils/global_context.dart';
import 'app_route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/features/bottom_nav_bar.dart';
import 'package:note_app/features/profile/view/profile_screen.dart';

final AuthUseCase _authUseCase = sl<AuthUseCase>();

final GoRouter appRouter = GoRouter(
  initialLocation: AppRouteNames.login,
  navigatorKey: GlobalContext.navigatorKey,
  redirect: (context, state) async {
    final loggedIn = await _authUseCase.isUserAlreadyLoggedIn();

    final goingToLogin = state.matchedLocation == AppRouteNames.login;
    final goingToSignup = state.matchedLocation == AppRouteNames.signup;
    final goingToVerifyEmail = state.matchedLocation == AppRouteNames.verifyEmail;

    // ✅ Not logged in: only allow login and signup
    if (!loggedIn && !goingToLogin && !goingToSignup && !goingToVerifyEmail) {
      return AppRouteNames.login;
    }

    // ✅ Already logged in: block login/signup
    if (loggedIn && (goingToLogin || goingToSignup || goingToVerifyEmail)) {
      return AppRouteNames.bottomNavBar;
    }

    return null;
  },
  routes: [
    GoRoute(path: AppRouteNames.login, builder: (context, state) => const LoginScreen()),
    GoRoute(path: AppRouteNames.signup, builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: AppRouteNames.verifyEmail,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return EmailVerificationScreen(
          userProfile: args['userProfile'] as UserModel,
          password: args['password'] as String,
        );
      },
    ),

    // Dashboard and Notes will be added later
    GoRoute(path: AppRouteNames.bottomNavBar, builder: (context, state) => const BottomNavBar()),
    GoRoute(path: AppRouteNames.dashboard, builder: (context, state) => const DashboardScreen()),
    GoRoute(path: AppRouteNames.createdNotes, builder: (context, state) => const CreateNoteScreen()),
    GoRoute(path: AppRouteNames.profile, builder: (context, state) => const ProfileScreen()),
  ],
);
