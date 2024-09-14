import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:chat_application/firebase_options.dart';

import 'package:chat_application/providers.dart';

//TODO(NOTE): 120hz以上のデバイスではアニメーション時例外が起こる
//参考URL: https://github.com/flutter/flutter/issues/106277

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //認証状態が変化したらルーターをリロードする
    ref.read(authProvider).authStateChanges().listen(
          (_) => ref.read(routerProvider).refresh(),
        );

    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
    );
  }
}
