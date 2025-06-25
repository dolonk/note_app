import 'app_route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



final GoRouter appRouter = GoRouter(
  initialLocation: AppRouteNames.login,
  routes: [
    GoRoute(
      path: AppRouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRouteNames.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRouteNames.verifyEmail,
      builder: (context, state) => const EmailVerificationScreen(),
    ),
    // Dashboard and Notes will be added later
  ],
);
