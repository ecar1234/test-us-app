

import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/models/message/message_model.dart';
import 'package:test_us_app/data/models/message/room_model.dart';

import '../../../core/net_driver.dart';
import 'message_data_source.dart';

class MessageDataSourceImpl implements MessageDataSource {
  final NetDriver netDriver;

  MessageDataSourceImpl(this.netDriver);

  @override
  Future<List<MessageModel>?> requestMessageByPostId(String token, String postId, String targetId) async {
    try {
      final res = await netDriver.requestPostJson(token, MessageApi.requestMessageByPostId, {'postId': postId, 'targetId': targetId});
      if (res['status'] == 200){
        if((res['messages'] as List<dynamic>).isEmpty){
          return [];
        }
        return res['messages'].map<MessageModel>((e) => MessageModel.fromJson(e)).toList();
      } else {
        return null;
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<MessageModel>> requestMessageByRoomId(String token, int roomId, String userId) async {
    final res = await netDriver.requestPostJson(token, MessageApi.requestMessageByRoomId, {'roomId': roomId, 'userId': userId});
    if (res['status'] == 200){
      if((res['messages'] as List<dynamic>).isEmpty){
        return [];
      }
      return res['messages'].map<MessageModel>((e) => MessageModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<RoomModel> resetUnreadCount(String token, int roomId, String userId) async {
    final res = await netDriver.requestPostJson(token, MessageApi.resetUnreadCount, {'roomId': roomId, 'userId': userId});
    if (res['status'] == 200){
      return RoomModel.fromJson(res['room']);
    } else {
      return RoomModel();
    }
  }
}