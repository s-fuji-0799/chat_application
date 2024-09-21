import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_application/providers/firebase.dart';

final userNotifierProvider = NotifierProvider<UserNotifier, User?>(
  () => UserNotifier(),
);

class UserNotifier extends Notifier<User?> {
  @override
  User? build() {
    return ref.watch(firebaseAuthProvider).currentUser;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCred =
          await ref.watch(firebaseAuthProvider).signInWithEmailAndPassword(
                email: email,
                password: password,
              );
      state = userCred.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCred =
          await ref.watch(firebaseAuthProvider).createUserWithEmailAndPassword(
                email: email,
                password: password,
              );
      state = userCred.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await ref.watch(firebaseAuthProvider).signOut();
      ref.invalidateSelf();
    } catch (e) {
      rethrow;
    }
  }
}
