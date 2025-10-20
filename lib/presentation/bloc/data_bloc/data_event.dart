

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';

import '../../../domain/entities/post_entity.dart';

class DataEvent {}

class ServiceStartEvent extends DataEvent {
  ServiceStartEvent();
}

// class RequestUserInfoEvent extends DataEvent {
//   BuildContext context;
//   RequestUserInfoEvent(this.context);
// }
//
class RequestInitDataEvent extends DataEvent {
  RequestInitDataEvent();
}
//
class RequestRecruitmentPaginationEvent extends DataEvent {
  RequestRecruitmentPaginationEvent();
}
//
class RequestPostDataEvent extends DataEvent {
  final String token;
  final String postId;
  RequestPostDataEvent(this.token, this.postId);
}
class RequestPostUpdateEvent extends DataEvent {
  final String token;
  final PostEntity post;
  RequestPostUpdateEvent(this.token, this.post);
}
//
class RequestPostCreateEvent extends DataEvent {
  String token;
  PostEntity post;
  RequestPostCreateEvent(this.token, this.post);
}
//
class RequestPostDeleteEvent extends DataEvent {
  final String token;
  final PostEntity post;
  RequestPostDeleteEvent(this.token, this.post);
}
//
class RequestPostImgRegisterEvent extends DataEvent {
  final String token;
  final List<XFile> images;
  final String postId;
  RequestPostImgRegisterEvent(this.token, this.images, this.postId);
}

class RequestPostImgUpdateEvent extends DataEvent {
  final String token;
  final List<ImageEntity> deleteImages;
  final List<XFile> images;
  final String postId;
  RequestPostImgUpdateEvent(this.token, this.deleteImages, this.images, this.postId);
}
//
class RequestPostImgDeleteEvent extends DataEvent {
  final String token;
  final List<ImageEntity> images;
  RequestPostImgDeleteEvent(this.token, this.images);
}
//
class RequestUserRecruitmentPosts extends DataEvent {
  final String token;
  final String userId;
  RequestUserRecruitmentPosts(this.token, this.userId);
}
//
class PostDataLoadEvent extends DataEvent {
  PostDataLoadEvent();
}

class RequestCompleteEvent extends DataEvent {
  RequestCompleteEvent();
}

class ReloadPostEvent extends DataEvent {
  ReloadPostEvent();
}

class DataLoadErrorEvent extends DataEvent {
  DataLoadErrorEvent();
}
