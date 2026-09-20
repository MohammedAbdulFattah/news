import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:news/core/constants/app_strings.dart';

class AuthenticationException implements Exception {
  final String message;

  const AuthenticationException(this.message);

  factory AuthenticationException.fromFirebase(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return const AuthenticationException(
          AppStrings.passwordWeak,
        );

      case 'email-already-in-use':
        return const AuthenticationException(
          AppStrings.emailAlreadyUsed,
        );

      case 'invalid-credential' || 'wrong-password' || 'user-not-found':
        return const AuthenticationException(AppStrings.invalidEmailOrPassword);

      case 'user-disabled':
        return const AuthenticationException(AppStrings.accountDisable);

      case 'network-request-failed':
        return const AuthenticationException(
          AppStrings.checkInternetConnection,
        );

      default:
        return const AuthenticationException(AppStrings.authenticationFailed);
    }
  }

  @override
  String toString() => message;
}
