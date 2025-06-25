import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/services/https_services/auth_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Supabase initialization must be called in main, not here
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  sl.registerLazySingleton<AuthService>(() => AuthService(sl()));
}
