import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat_application/notifiers/user_notifier.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント'),
      ),
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
