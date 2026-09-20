import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/data/models/login_credential.dart';
import 'package:news/data/models/sign_up_credential.dart';
import 'package:news/providers/authentication_provider.dart';

class AuthenticationNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    return ref.read(authenticationRepositoryProvider).currentUser;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final loginCredential = LoginCredential(email: email, password: password);

    state = await AsyncValue.guard(() async {
      final userCredential = await ref
          .read(authenticationRepositoryProvider)
          .login(loginCredential);
      return userCredential.user;
    });
  }

  Future<void> signUp(String email, String password, String name) async {
    state = const AsyncLoading();
    final signUpCredential = SignUpCredential(
      email: email,
      password: password,
      name: name,
    );

    state = await AsyncValue.guard(() async {
      final userCredential = await ref
          .read(authenticationRepositoryProvider)
          .signUp(signUpCredential);
      return userCredential.user;
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final userCredential = await ref
          .read(authenticationRepositoryProvider)
          .signInWithGoogle();
      return userCredential.user;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authenticationRepositoryProvider).logout();
      return null;
    });
  }
}

class AuthenticationTabIndex extends Notifier<int> {
  @override
  int build() => 0;

  void set(int i) => state = i;
}
