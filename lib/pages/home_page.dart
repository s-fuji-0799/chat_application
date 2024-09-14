import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat_application/providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await ref.read(authProvider).signOut();
            } catch (e) {
              print(e);
            }
          },
          child: Text('ログアウト'),
        ),
      ),
    );
  }
}
