

import 'package:flutter/material.dart';

import '../../domain/entities/room_entity.dart';

class RoomProvider with ChangeNotifier {
  List<RoomEntity> _roomList = [];

  List<RoomEntity> get roomList => _roomList;

  void setRoomList(List<RoomEntity> roomList) {
    if (roomList.isEmpty) return;
    _roomList = roomList;
    notifyListeners();
  }
}