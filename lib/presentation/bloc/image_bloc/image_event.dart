

import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/image_entity.dart';

class ImageEvent {}

class RequestPostImgRegisterEvent extends ImageEvent {
  final String token;
  final List<XFile> images;
  final String postId;
  RequestPostImgRegisterEvent(this.token, this.images, this.postId);
}

class RequestPostImgUpdateEvent extends ImageEvent {
  final String token;
  final List<ImageEntity> deleteImages;
  final List<XFile> images;
  final String postId;
  RequestPostImgUpdateEvent(this.token, this.deleteImages, this.images, this.postId);
}
//
class RequestPostImgDeleteEvent extends ImageEvent {
  final String token;
  final List<ImageEntity> images;
  RequestPostImgDeleteEvent(this.token, this.images);
}