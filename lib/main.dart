import 'core/env/env.dart';
import 'core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:note_app/route/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase using your Env class
  await Supabase.initialize(url: Env.SUPABASE_URL, anonKey: Env.SUPABASE_ANON_KEY);

  // ✅ Register dependencies
  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Note app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      routerConfig: appRouter,
    );
  }
}
