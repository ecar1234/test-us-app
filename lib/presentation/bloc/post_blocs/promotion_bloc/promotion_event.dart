
import 'package:image_picker/image_picker.dart';

import '../../../../domain/entities/image_entity.dart';
import '../../../../domain/entities/promotion_post_entity.dart';

class PromotionEvent {}

class RequestPromotionPaginationEvent extends PromotionEvent {
  int page;
  int size;
  RequestPromotionPaginationEvent(this.page, this.size);
}

//
class RequestPostCreateEvent extends PromotionEvent {
  String token;
  PromotionPostEntity post;
  List<XFile> selectedImages;
  RequestPostCreateEvent(this.token, this.post, this.selectedImages);
}
//
class RequestPostUpdateEvent extends PromotionEvent {
  String token;
  PromotionPostEntity? post;
  List<XFile> selectedImages;
  List<ImageEntity> deletedImages;
  RequestPostUpdateEvent(this.token, this.post, this.selectedImages, this.deletedImages);
}
//
class RequestPostDeleteEvent extends PromotionEvent {
  final String token;
  final PromotionPostEntity post;
  RequestPostDeleteEvent(this.token, this.post);
}
//
class RequestPromotionPostDataEvent extends PromotionEvent {
  final String token;
  final String postId;
  RequestPromotionPostDataEvent(this.token, this.postId);
}
//
class RequestUserPromotionPosts extends PromotionEvent {
  final String token;
  final String userId;
  RequestUserPromotionPosts(this.token, this.userId);
}
//
class PostDataLoadEvent extends PromotionEvent {
  PostDataLoadEvent();
}

class RequestCompleteEvent extends PromotionEvent {
  RequestCompleteEvent();
}

class ReloadPostEvent extends PromotionEvent {
  ReloadPostEvent();
}

class DataLoadErrorEvent extends PromotionEvent {
  DataLoadErrorEvent();
}
