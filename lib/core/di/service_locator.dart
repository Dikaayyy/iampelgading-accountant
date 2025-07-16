import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Auth
import 'package:iampelgading/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:iampelgading/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:iampelgading/features/auth/domain/repositories/auth_repository.dart';
import 'package:iampelgading/features/auth/domain/usecases/login_usecase.dart';
import 'package:iampelgading/features/auth/presentation/providers/auth_provider.dart';

// Transaction
import 'package:iampelgading/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:iampelgading/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:iampelgading/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:iampelgading/features/transaction/domain/usecases/add_transaction.dart';
import 'package:iampelgading/features/transaction/domain/usecases/get_transactions_usecase.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';

// Core
import 'package:iampelgading/core/services/auth_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());

  // Core services
  sl.registerLazySingleton<AuthService>(() => AuthService(sl()));

  // Auth feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl(), authService: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), authService: sl()),
  );

  sl.registerLazySingleton(() => LoginUsecase(sl()));

  sl.registerFactory(() => AuthProvider(loginUsecase: sl()));

  // Transaction feature
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(client: sl(), authService: sl()),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => GetTransactions(sl()));

  sl.registerFactory(() => TransactionProvider(sl(), sl()));
}
