# Environment Configuration Guide

## Overview
This project uses environment-specific configuration files for development and production modes.

## Files

### `.env.dev`
Development environment configuration. Contains:
- Development API endpoints
- Debug logging enabled
- Feature flags disabled for testing
- Relaxed API timeouts for debugging

### `.env.prod`
Production environment configuration. Contains:
- Production API endpoints
- Minimal logging for performance
- Feature flags enabled
- Standard API timeouts

### `.env.example`
Template file showing all available environment variables. Use this as reference when creating new `.env` files.

### `lib/core/config/env_config.dart`
Dart configuration class that provides access to environment variables. Supports:
- Switching between development and production modes
- Getting environment-specific configuration values
- Checking current environment status

## Usage

### 1. Select Environment in main.dart

Update `main.dart` to initialize the environment before running the app:

```dart
import 'package:tithi_gadhi/core/config/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set environment (use 'production' for prod builds)
  EnvConfig.setEnvironment('development');
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureDependencies();
  runApp(const MyApp());
}
```

### 2. Access Configuration in Your Code

```dart
import 'package:tithi_gadhi/core/config/env_config.dart';

// Get configuration values
final apiUrl = EnvConfig.apiBaseUrl;
final debugMode = EnvConfig.debugMode;
final enableLogging = EnvConfig.enableRequestLogging;

// Check environment
if (EnvConfig.isDevelopment) {
  // Development-specific code
} else if (EnvConfig.isProduction) {
  // Production-specific code
}
```

### 3. Build Commands

For development:
```bash
flutter run --dart-define=ENVIRONMENT=development
```

For production:
```bash
flutter run --dart-define=ENVIRONMENT=production
```

Or use flavor-specific builds (if configured).

## Environment Variables

### API Configuration
- `API_BASE_URL`: Base URL for API requests
- `API_TIMEOUT_SECONDS`: Request timeout in seconds

### Environment Settings
- `ENVIRONMENT`: Current environment (development/production)
- `DEBUG_MODE`: Enable/disable debug mode
- `LOG_LEVEL`: Logging level (debug/info/error)

### Feature Flags
- `ENABLE_ANALYTICS`: Enable analytics tracking
- `ENABLE_CRASH_REPORTING`: Enable crash reporting
- `ENABLE_REQUEST_LOGGING`: Log HTTP requests
- `ENABLE_RESPONSE_LOGGING`: Log HTTP responses

### App Info
- `APP_VERSION`: Application version
- `BUILD_NUMBER`: Build number

## Security Notes

⚠️ **Important**: 
- **Do NOT commit** `.env*` files to version control
- Add `.env*` to `.gitignore` (except `.env.example`)
- Store sensitive data (API keys, tokens) in secure storage
- Use Firebase Secure Storage for authentication tokens
- Keep production credentials in secure vaults/secret management systems

## Adding More Variables

To add new environment variables:

1. Add the variable to `.env.dev` and `.env.prod`
2. Add it to `.env.example` with documentation
3. Add constants to both dev and prod sections in `env_config.dart`
4. Add getter properties to access the values

Example:
```dart
// In env_config.dart
static const String devFirebaseProjectId = 'tithi-gadhi-dev';
static const String prodFirebaseProjectId = 'tithi-gadhi-prod';

static String get firebaseProjectId =>
    isDevelopment ? devFirebaseProjectId : prodFirebaseProjectId;
```

## Alternatives

If you prefer using the `flutter_dotenv` package:

1. Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter_dotenv: ^5.0.0
```

2. Load in `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(
    fileName: isProd ? '.env.prod' : '.env.dev',
  );
  // ... rest of your code
}
```

3. Access variables:
```dart
final apiUrl = dotenv.env['API_BASE_URL'];
```

The `EnvConfig` class approach is lighter and requires no additional dependencies.
