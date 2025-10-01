

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';

import '../../../domain/entities/post_entity.dart';

class DataEvent {}

class ServiceStartEvent extends DataEvent {
  ServiceStartEvent();
}

class RequestUserInfoEvent extends DataEvent {
  BuildContext context;
  RequestUserInfoEvent(this.context);
}

class RequestInitDataEvent extends DataEvent {
  BuildContext context;
  RequestInitDataEvent(this.context);
}

class RequestPostDataEvent extends DataEvent {
  BuildContext context;
  int page;
  RequestPostDataEvent(this.context, this.page);
}

class GetPostDetailEvent extends DataEvent {
  BuildContext context;
  String postId;
  String token;
  GetPostDetailEvent(this.context, this.postId, this.token);
}
class RequestPostUpdateEvent extends DataEvent {
  BuildContext context;
  PostEntity post;
  String token;
  RequestPostUpdateEvent(this.context, this.token, this.post);
}
class RequestPostDeleteEvent extends DataEvent {
  BuildContext context;
  PostEntity post;
  String token;
  RequestPostDeleteEvent(this.context, this.token, this.post);
}

class RequestPostCreateEvent extends DataEvent {
  BuildContext context;
  String token;
  PostEntity post;
  RequestPostCreateEvent(this.context, this.post, this.token);
}

class RequestPostImgRegisterEvent extends DataEvent {
  BuildContext context;
  String token;
  List<XFile>? images;
  String postId;
  RequestPostImgRegisterEvent(this.context, this.token, this.images, this.postId);
}

class RequestPostImgUpdateEvent extends DataEvent {
  BuildContext context;
  String token;
  List<ImageEntity> deleteImages;
  List<XFile>? images;
  String postId;
  RequestPostImgUpdateEvent(this.context, this.token, this.deleteImages , this.images, this.postId);
}

class RequestPostImgDeleteEvent extends DataEvent {
  BuildContext context;
  String token;
  List<ImageEntity> deleteImages;
  RequestPostImgDeleteEvent(this.context, this.token, this.deleteImages);
}

class RequestCompleteEvent extends DataEvent {
  RequestCompleteEvent();
}

class ReloadPostEvent extends DataEvent {
  ReloadPostEvent();
}
