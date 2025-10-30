

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';

import '../../../../domain/entities/recruit_post_entity.dart';


class RecruitPostEvent {}

class RequestRecruitmentPaginationEvent extends RecruitPostEvent {
  int page;
  int size;
  RequestRecruitmentPaginationEvent(this.page, this.size);
}
//
class RequestPostDataEvent extends RecruitPostEvent {
  final String token;
  final String postId;
  RequestPostDataEvent(this.token, this.postId);
}
class RequestPostUpdateEvent extends RecruitPostEvent {
  String token;
  RecruitPostEntity post;
  List<XFile> selectedImages;
  List<ImageEntity> deletedImages;
  RequestPostUpdateEvent(this.token, this.post, this.selectedImages, this.deletedImages);
}
//
class RequestPostCreateEvent extends RecruitPostEvent {
  String token;
  RecruitPostEntity post;
  List<XFile> selectedImages;
  RequestPostCreateEvent(this.token, this.post, this.selectedImages);
}
//
class RequestPostDeleteEvent extends RecruitPostEvent {
  final String token;
  final RecruitPostEntity post;
  RequestPostDeleteEvent(this.token, this.post);
}
//
class RequestUserRecruitmentPosts extends RecruitPostEvent {
  final String token;
  final String userId;
  RequestUserRecruitmentPosts(this.token, this.userId);
}
//
class PostDataLoadEvent extends RecruitPostEvent {
  PostDataLoadEvent();
}

class RequestCompleteEvent extends RecruitPostEvent {
  RequestCompleteEvent();
}

class ReloadPostEvent extends RecruitPostEvent {
  ReloadPostEvent();
}

class DataLoadErrorEvent extends RecruitPostEvent {
  DataLoadErrorEvent();
}
