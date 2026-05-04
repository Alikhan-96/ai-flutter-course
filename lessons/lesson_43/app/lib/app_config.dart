enum Flavor { dev, prod }

class AppConfig {
  static Flavor _flavor = Flavor.dev;

  static Flavor get flavor => _flavor;

  static void init(Flavor flavor) {
    _flavor = flavor;
  }

  static bool get isDev => _flavor == Flavor.dev;
  static bool get isProd => _flavor == Flavor.prod;

  static String get appName => isDev ? 'MyApp (Dev)' : 'MyApp';

  static String get apiBaseUrl => isDev
      ? 'https://dev.api.example.com'
      : 'https://api.example.com';
}
