/// Application configuration
class AppConfig {
  /// Check if the app is running in debug mode
  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;

  /// Check if the app is running in release mode
  static const bool isRelease = bool.fromEnvironment('dart.vm.product');

  /// Use mock API in debug mode
  static bool get useMockApi => isDebug;
}
