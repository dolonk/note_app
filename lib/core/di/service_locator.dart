import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data_layer/data_sources/remote/auth_remote_datasource.dart';
import '../../data_layer/domain/repositories/auth/auth_repository.dart';
import '../../data_layer/domain/repositories/auth/auth_repository_impl.dart';
import '../../data_layer/domain/use_cases/auth_use_case.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  /// Auth section
  sl.registerLazySingleton(() => AuthRemoteData(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => AuthUseCase(sl()));
}
