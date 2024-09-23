import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat_application/models/room_model.dart';
import 'package:chat_application/repositories/room_repository.dart';

final roomListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<RoomListNotifier, List<RoomModel>>(
  () => RoomListNotifier(),
);

class RoomListNotifier extends AutoDisposeAsyncNotifier<List<RoomModel>> {
  Future<List<RoomModel>> _fetchRoom() async {
    return await ref.watch(roomRepositoryProvider).fetchRooms();
  }

  @override
  FutureOr<List<RoomModel>> build() {
    return _fetchRoom();
  }

  Future<void> fetchRoom() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => _fetchRoom());
  }

  Future<void> addRoom({required String name}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await ref.watch(roomRepositoryProvider).addRoom(name: name);
        return _fetchRoom();
      },
    );
  }
}
