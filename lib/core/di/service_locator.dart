import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:iampelgading/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:iampelgading/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:iampelgading/features/auth/domain/repositories/auth_repository.dart';
import 'package:iampelgading/features/auth/domain/usecases/login_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  sl.registerLazySingleton(() => http.Client());

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
}
