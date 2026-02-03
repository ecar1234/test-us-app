import 'package:flutter/material.dart';

import '../../domain/entities/message_entity.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/use_cases/message_usecase.dart';

class RoomProvider with ChangeNotifier {
  final MessageUseCase _messageUseCase;

  RoomProvider(this._messageUseCase);

  List<RoomEntity>? _roomList;

  List<RoomEntity>? get roomList => _roomList;

  void setRoomList(List<RoomEntity> roomList) {
    _roomList = roomList;
    notifyListeners();
  }

  Future<void> addRoom(MessageEntity message) async {
    _roomList ??= [];

    final existingIndex = _roomList!.indexWhere((e) => e.id == message.roomId);

    if (existingIndex != -1) {
      final oldRoom = _roomList![existingIndex];
      final updatedRoom = RoomEntity(
        id: oldRoom.id,
        post: oldRoom.post,
        type: oldRoom.type,
        members: oldRoom.members,
        targetUserId: message.sender!.userId,
        createdAt: oldRoom.createdAt,
        lastMessage: message,
        lastMessageAt: message.createdAt,
        lastMessageContent: message.content,
      );

      _roomList = [updatedRoom, ..._roomList!.where((e) => e.id != message.roomId)];
    } else {
      final newRoom = await _messageUseCase.requestRoomInfoById(message.roomId!);
      _roomList = [newRoom, ..._roomList!];
    }
    notifyListeners();
  }

  void resetMemberCount(int roomId) {
    final index = _roomList!.indexWhere((e) => e.id == roomId);
    if (index != -1) {
      final room = _roomList![index];
      for (var member in room.members!) {
        member.unreadCount = 0;
      }
      _roomList = List.from(_roomList!)..[index] = room;
      notifyListeners();
    }
  }
}
