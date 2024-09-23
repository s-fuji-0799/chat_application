import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat_application/models/room_model.dart';
import 'package:chat_application/notifiers/room_list_notifier.dart';

class RoomListPage extends ConsumerStatefulWidget {
  const RoomListPage({super.key});

  @override
  ConsumerState<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends ConsumerState<RoomListPage> {
  @override
  Widget build(BuildContext context) {
    final asyncRoomList = ref.watch(roomListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('チャットルーム一覧'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/chat-rooms/create'),
        child: const Icon(Icons.add),
      ),
      body: switch (asyncRoomList) {
        AsyncData(:final value) => RefreshIndicator(
            child: RoomListView(roomList: value),
            onRefresh: () =>
                ref.watch(roomListNotifierProvider.notifier).fetchRoom(),
          ),
        AsyncError(:final error) => const Center(child: Text('error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class RoomListView extends StatelessWidget {
  const RoomListView({super.key, required this.roomList});

  final List<RoomModel> roomList;

  @override
  Widget build(BuildContext context) {
    if (roomList.isEmpty) {
      return ListView(
        children: const [Center(child: Text('チャットルームがありません'))],
      );
    }

    return ListView.builder(
      itemCount: roomList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(roomList[index].name),
          onTap: () {},
        );
      },
    );
  }
}
