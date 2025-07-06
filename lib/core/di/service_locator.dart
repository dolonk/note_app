import 'package:get_it/get_it.dart';
import 'package:note_app/data_layer/domain/repositories/notes/remote/remote_note_repository.dart';
import 'package:note_app/data_layer/domain/repositories/notes/remote/remote_note_repository_impl.dart';
import 'package:note_app/data_layer/domain/use_cases/local_note_use_case.dart';
import 'package:note_app/data_layer/domain/use_cases/remote_note_use_case.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data_layer/data_sources/local/note_local_datasource.dart';
import '../../data_layer/data_sources/remote/auth_remote_datasource.dart';
import '../../data_layer/data_sources/remote/note_remote_datasource.dart';
import '../../data_layer/domain/repositories/auth/auth_repository.dart';
import '../../data_layer/domain/repositories/auth/auth_repository_impl.dart';
import '../../data_layer/domain/repositories/notes/local/local_note_repository.dart';
import '../../data_layer/domain/repositories/notes/local/local_note_repository_impl.dart';
import '../../data_layer/domain/use_cases/auth_use_case.dart';
import '../../features/auth/provider/auth_provider.dart';
import '../../features/note/provider/note_provider.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 🧠 Initialize Supabase
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // 🧠 Auth Remote Datasource
  sl.registerLazySingleton(() => AuthRemoteData(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => AuthUseCase(sl()));
  sl.registerLazySingleton<AuthProvider>(() => AuthProvider());

  // 🧠 Remote Note Repository
  sl.registerLazySingleton(() => RemoteNoteDataSource(sl()));
  sl.registerLazySingleton<RemoteNoteRepository>(() => RemoteNoteRepositoryImpl(sl()));
  sl.registerLazySingleton(() => RemoteNoteUseCase(sl()));

  // 🧠 Local SQLite Datasource & Local Note repository
  sl.registerLazySingleton<LocalNoteDataSource>(() => LocalNoteDataSourceImpl());
  sl.registerLazySingleton<LocalNoteRepository>(() => LocalNoteRepositoryImpl(sl()));
  sl.registerLazySingleton(() => LocalNoteUseCase(sl()));
  sl.registerLazySingleton<NoteProvider>(() => NoteProvider());
}
