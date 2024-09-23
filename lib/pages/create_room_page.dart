import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat_application/notifiers/room_list_notifier.dart';

//TODO: 部屋名が空白時の対応（バリデーション）
class CreateRoomPage extends ConsumerStatefulWidget {
  const CreateRoomPage({super.key});

  @override
  ConsumerState<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends ConsumerState<CreateRoomPage> {
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャットルーム作成'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'チャットルーム名',
              ),
              onChanged: (value) => name = value,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.watch(roomListNotifierProvider.notifier).addRoom(
                        name: name,
                      );
                  if (context.mounted) {
                    context.pop();
                  }
                } catch (e) {
                  rethrow;
                }
              },
              child: const Text('ルーム作成'),
            ),
          ],
        ),
      ),
    );
  }
}
