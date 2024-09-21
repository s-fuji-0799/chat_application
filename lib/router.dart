import 'package:chat_application/pages/room_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:chat_application/notifiers/user_notifier.dart';

import 'package:chat_application/pages/auth_page.dart';
import 'package:chat_application/pages/account_page.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final user = ref.watch(userNotifierProvider);

    return GoRouter(
      initialLocation: '/chat-rooms',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return Scaffold(
              body: navigationShell,
              bottomNavigationBar: NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (value) =>
                    navigationShell.goBranch(value),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.chat),
                    label: 'チャット',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.account_circle),
                    label: 'アカウント',
                  ),
                ],
              ),
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/chat-rooms',
                  builder: (context, state) => const RoomListPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/account',
                  builder: (context, state) => const AccountPage(),
                ),
              ],
            ),
          ],
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
            return '/chat-rooms';
          }
        }
        return null;
      },
    );
  },
);
