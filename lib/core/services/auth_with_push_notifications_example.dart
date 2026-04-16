// This is an example of how to integrate push notifications with your auth flow
// Copy the relevant parts into your actual auth service/cubit

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:tithi_gadhi/core/network/dio_client.dart';
import 'package:tithi_gadhi/core/services/fcm_service.dart';
import 'package:tithi_gadhi/core/services/push_notification_service.dart';

class AuthServiceWithPushNotifications {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final PushNotificationService _pushNotificationService;

  AuthServiceWithPushNotifications() {
    _pushNotificationService = PushNotificationService(GetIt.I<DioClient>());
  }

  /// Example: Sign in with Google
  Future<User?> signInWithGoogle(String idToken) async {
    try {
      // 1. Authenticate with Firebase
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null && user.providerData.isNotEmpty) {
        // 2. Get FCM token
        final fcmToken = FcmService().fcmToken;

        // 3. Register device with backend
        if (fcmToken != null) {
          await _pushNotificationService.registerDeviceWithBackend(
            idToken: idToken,
            fcmToken: fcmToken,
            deviceName: 'Mobile Device', // Optional: get actual device name
          );
        }

        // 4. Subscribe to user-specific notifications
        await _pushNotificationService.subscribeToUserNotifications(
          user.uid,
        );
      }

      return user;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Example: Sign in with Facebook
  Future<User?> signInWithFacebook(String accessToken, String idToken) async {
    try {
      // 1. Authenticate with Firebase
      final credential = FacebookAuthProvider.credential(accessToken);
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // 2-4. Same push notification setup as Google sign-in
        await _setupPushNotifications(user.uid, idToken);
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Common push notification setup logic
  Future<void> _setupPushNotifications(
    String userId,
    String idToken,
  ) async {
    try {
      final fcmToken = FcmService().fcmToken;

      if (fcmToken != null && idToken.isNotEmpty) {
        await _pushNotificationService.registerDeviceWithBackend(
          idToken: idToken,
          fcmToken: fcmToken,
          deviceName: 'Mobile Device',
        );
      }

      await _pushNotificationService.subscribeToUserNotifications(userId);
    } catch (e) {
      // Don't rethrow - notification setup failure shouldn't block login
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        // 1. Get current ID token
        final idToken = await user.getIdToken();

        // 2. Unregister device from backend
        if (idToken != null && idToken.isNotEmpty) {
          await _pushNotificationService.unregisterDeviceFromBackend(
            idToken: idToken,
          );
        }

        // 3. Unsubscribe from notifications
        await _pushNotificationService.unsubscribeFromUserNotifications(
          user.uid,
        );
      }

      // 4. Delete local FCM token
      await FcmService().deleteToken();

      // 5. Sign out from Firebase
      await _firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Monitor auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => _firebaseAuth.currentUser != null;
}

// ═══════════════════════════════════════════════════════════════════════════
// INTEGRATION WITH BLoC/CUBIT PATTERN
// ═══════════════════════════════════════════════════════════════════════════

// Example of how to integrate with your BLoC/Cubit pattern:

/*
class AuthCubit extends Cubit<AuthState> {
  final AuthServiceWithPushNotifications _authService;
  late StreamSubscription _authStateSubscription;

  AuthCubit(this._authService) : super(const AuthState.initial()) {
    _initAuthStateListener();
  }

  void _initAuthStateListener() {
    _authStateSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  Future<void> signInWithGoogle(String idToken) async {
    try {
      emit(const AuthState.loading());
      final user = await _authService.signInWithGoogle(idToken);
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.error('Sign in failed'));
      }
    } catch (e) {
      emit(AuthState.error('Error: $e'));
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error('Error signing out: $e'));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}
*/

// ═══════════════════════════════════════════════════════════════════════════
// HOW TO USE IN YOUR WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

/*
// In your login widget:
class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Get your ID token from Google Sign-In or Firebase Auth
        final idToken = '...'; // from Google Sign-In

        context.read<AuthCubit>().signInWithGoogle(idToken);
      },
      child: const Text('Sign in with Google'),
    );
  }
}

// In your app widget to listen to auth state:
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (user) {
            // Navigate to home
            context.go('/home');
          },
          unauthenticated: () {
            // Navigate to login
            context.go('/login');
          },
          error: (message) {
            // Show error dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
        );
      },
      child: MaterialApp.router(
        routerConfig: appRouter.config,
      ),
    );
  }
}
*/
