

import 'package:flutter/material.dart';

import '../../domain/entities/room_entity.dart';
import '../../domain/use_cases/message_usecase.dart';

class RoomProvider with ChangeNotifier {
  final MessageUseCase _messageUseCase;
  RoomProvider(this._messageUseCase);

  List<RoomEntity> _roomList = [];

  List<RoomEntity> get roomList => _roomList;

  void setRoomList(List<RoomEntity> roomList) {
    if (roomList.isEmpty) return;
    _roomList = roomList;
    notifyListeners();
  }

  Future<void> addRoom(int roomId)async{
    if(_roomList.any((element) => element.id == roomId)) return;
    final room = await _messageUseCase.requestRoomInfoById(roomId);
    _roomList.add(room);
  }
}