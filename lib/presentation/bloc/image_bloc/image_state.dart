

import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

enum ImageLoadState {
  beforeImageUploadState,
  imageUploadingState,
  imageUploadCompletedState,
  imageUpdateCompletedState,
  imageDeleteCompletedState,
  imageUploadFailedState,
  imageUploadErrorState,
}

class ImageState {
  ImageLoadState state;
  RecruitPostEntity? post;
  ImageState({this.state = ImageLoadState.beforeImageUploadState, this.post});
}