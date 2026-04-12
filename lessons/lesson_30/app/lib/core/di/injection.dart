import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/api/api_client.dart';
import '../../data/api/mock_api_client.dart';
import '../../data/api/real_api_client.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../config/app_config.dart';

/// Global instance of GetIt
final getIt = GetIt.instance;

/// Initialize all dependencies
/// Returns Future to support async initialization
Future<void> initializeDependencies() async {
  // === Async Initialization ===
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Save app launch time
  await sharedPreferences.setString(
    'last_launch',
    DateTime.now().toIso8601String(),
  );

  // === Data Layer ===
  // Register API Client based on build mode
  if (AppConfig.useMockApi) {
    print('🔧 Registering MockApiClient (Debug Mode)');
    getIt.registerSingleton<ApiClient>(MockApiClient());
  } else {
    print('🚀 Registering RealApiClient (Release Mode)');
    getIt.registerSingleton<ApiClient>(RealApiClient());
  }

  // Register Repository (singleton)
  getIt.registerSingleton<UserRepository>(
    UserRepositoryImpl(getIt<ApiClient>()),
  );

  // === Domain Layer ===
  // Register Use Case (factory - new instance each time)
  getIt.registerFactory<GetUsersUseCase>(
    () => GetUsersUseCase(getIt<UserRepository>()),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
