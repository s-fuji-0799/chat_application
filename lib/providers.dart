import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_application/pages/auth_page.dart';
import 'package:chat_application/pages/home_page.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthPage(),
          routes: [
            GoRoute(
              path: 'signup',
              builder: (context, state) => const SignUpPage(),
            ),
            GoRoute(
              path: 'login',
              builder: (context, state) => const LoginPage(),
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        //認証状態によって遷移先を変える
        final user = ref.read(authProvider).currentUser;

        if (user == null) {
          if (RegExp(r'^/auth.*').hasMatch(state.matchedLocation)) {
            return null;
          }
          return '/auth';
        } else {
          if (RegExp(r'^/auth.*').hasMatch(state.matchedLocation)) {
            return '/';
          }
        }
        return null;
      },
    );
  },
);

final authProvider = Provider((ref) => FirebaseAuth.instance);
