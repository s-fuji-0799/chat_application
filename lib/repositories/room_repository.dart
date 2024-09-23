import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_application/infrastructures.dart';
import 'package:chat_application/models/room_model.dart';

final roomRepositoryProvider =
    Provider((ref) => RoomRepository(ref.watch(firestoreProvider)));

class RoomRepository {
  RoomRepository(
    this._instance,
  ) {
    _roomRef = _instance.collection('rooms').withConverter<RoomModel>(
      fromFirestore: (snapshot, _) {
        final json = snapshot.data()!;

        final convertedJson = json.map(
          (key, value) {
            final dynamic convertedValue;

            if (value is Timestamp) {
              convertedValue = value.toDate();
            } else {
              convertedValue = value;
            }

            return MapEntry(key, convertedValue);
          },
        );

        convertedJson['id'] = snapshot.id;

        return RoomModel.fromJson(convertedJson);
      },
      toFirestore: (value, _) {
        final json = value.toJson();

        final convertedJson = json.map(
          (key, value) {
            final dynamic convertedValue;

            if (value is DateTime) {
              convertedValue = Timestamp.fromDate(value);
            } else {
              convertedValue = value;
            }

            return MapEntry(key, convertedValue);
          },
        );
        convertedJson.remove('id');

        return convertedJson;
      },
    );
  }

  final FirebaseFirestore _instance;
  late final CollectionReference<RoomModel> _roomRef;

  Future<List<RoomModel>> fetchRooms() async {
    final rooms = await _roomRef.get();
    return rooms.docs.map((e) => e.data()).toList();
  }

  Future<void> addRoom({required String name}) async {
    final docRef = _roomRef.doc();
    await docRef.set(
      RoomModel(
        id: docRef.id,
        name: name,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
