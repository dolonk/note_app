import 'package:note_app/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import 'core/env/env.dart';
import 'core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:note_app/route/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with Env values
  await Supabase.initialize(url: Env.SUPABASE_URL, anonKey: Env.SUPABASE_ANON_KEY);

  // Setup dependency injection
  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Jodi onno provider thake, ekhane add korte parbi
      ],
      child: MaterialApp.router(
        title: 'Note App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        routerConfig: appRouter,
      ),
    );
  }
}
