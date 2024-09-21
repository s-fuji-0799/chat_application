import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:chat_application/providers/notifiers.dart';

import 'package:chat_application/pages/auth_page.dart';
import 'package:chat_application/pages/home_page.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final user = ref.watch(userNotifierProvider);

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
              path: 'signin',
              builder: (context, state) => const SignInPage(),
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        //認証状態によって遷移先を変える
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
