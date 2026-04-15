/// Environment configuration class to manage different environment modes
class EnvConfig {
  static const String _devEnv = 'development';
  static const String _prodEnv = 'production';

  // Development API Configuration
  static const String devApiBaseUrl = 'https://tithighadi.com/';
  static const int devApiTimeout = 30;
  static const bool devDebugMode = true;
  static const String devLogLevel = 'debug';
  static const bool devEnableRequestLogging = true;
  static const bool devEnableResponseLogging = true;
  static const bool devEnableAnalytics = false;
  static const bool devEnableCrashReporting = false;

  // Production API Configuration
  static const String prodApiBaseUrl = 'https://api.example.com/';
  static const int prodApiTimeout = 30;
  static const bool prodDebugMode = false;
  static const String prodLogLevel = 'error';
  static const bool prodEnableRequestLogging = false;
  static const bool prodEnableResponseLogging = false;
  static const bool prodEnableAnalytics = true;
  static const bool prodEnableCrashReporting = true;

  /// Set the current environment mode
  static String _currentEnvironment = _devEnv;

  /// Initialize environment with [environment] mode
  static void setEnvironment(String environment) {
    if (environment != _devEnv && environment != _prodEnv) {
      throw ArgumentError('Invalid environment: $environment');
    }
    _currentEnvironment = environment;
  }

  /// Get current environment
  static String get currentEnvironment => _currentEnvironment;

  /// Check if running in development mode
  static bool get isDevelopment => _currentEnvironment == _devEnv;

  /// Check if running in production mode
  static bool get isProduction => _currentEnvironment == _prodEnv;

  /// Get API base URL based on current environment
  static String get apiBaseUrl =>
      isDevelopment ? devApiBaseUrl : prodApiBaseUrl;

  /// Get API timeout based on current environment
  static int get apiTimeout =>
      isDevelopment ? devApiTimeout : prodApiTimeout;

  /// Get debug mode status
  static bool get debugMode =>
      isDevelopment ? devDebugMode : prodDebugMode;

  /// Get log level
  static String get logLevel =>
      isDevelopment ? devLogLevel : prodLogLevel;

  /// Check if request logging is enabled
  static bool get enableRequestLogging =>
      isDevelopment ? devEnableRequestLogging : prodEnableRequestLogging;

  /// Check if response logging is enabled
  static bool get enableResponseLogging =>
      isDevelopment ? devEnableResponseLogging : prodEnableResponseLogging;

  /// Check if analytics is enabled
  static bool get enableAnalytics =>
      isDevelopment ? devEnableAnalytics : prodEnableAnalytics;

  /// Check if crash reporting is enabled
  static bool get enableCrashReporting =>
      isDevelopment ? devEnableCrashReporting : prodEnableCrashReporting;
}
