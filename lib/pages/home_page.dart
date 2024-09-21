import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat_application/providers/notifiers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(ref.watch(userNotifierProvider)!.uid),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.watch(userNotifierProvider.notifier).signOut();
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('ログアウト'),
            ),
          ],
        ),
      ),
    );
  }
}
