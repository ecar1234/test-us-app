

import 'package:test_us_app/domain/entities/post_entity.dart';

enum ImageLoadState {
  beforeImageUploadState,
  imageUploadingState,
  imageUploadCompletedState,
  imageUploadFailedState,
  imageUploadErrorState,
}

class ImageState {
  ImageLoadState state;
  PostEntity? post;
  ImageState({this.state = ImageLoadState.beforeImageUploadState, this.post});
}