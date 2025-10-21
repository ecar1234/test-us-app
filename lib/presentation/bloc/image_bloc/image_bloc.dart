

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../domain/use_cases/image_usecase.dart';
import 'image_event.dart';
import 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final logger = Logger();
  ImageBloc(ImageUseCase userCase) : super(ImageState(state: ImageLoadState.beforeImageUploadState)){
    on<RequestPostImgRegisterEvent>((event, emit) async {
      final result = await userCase.registerPostImg(event.token, event.images, event.postId);
      emit(ImageState(state: ImageLoadState.imageUploadCompletedState, post: result));
      logger.i("data state : postImgRegisterCompletedState");
    });

    on<RequestPostImgUpdateEvent>((event, emit) async {
      final result = await userCase.updatePostImg(event.token, event.deleteImages, event.images, event.postId);
      emit(ImageState(state: ImageLoadState.imageUploadCompletedState, post: result));
      logger.i("data state : postImgUpdateCompletedState");
    });
    //
    on<RequestPostImgDeleteEvent>((event, emit) async {
      emit(ImageState(state: ImageLoadState.imageUploadingState));
      final res = await userCase.deletePostImg(event.token, event.images);
      if(res){
        emit(ImageState(state: ImageLoadState.imageUploadCompletedState));
        logger.i("data state : postImgDeleteCompletedState");
      }else {
        emit(ImageState(state: ImageLoadState.imageUploadErrorState));
        logger.i("data state : errorState");
      }
    });
  }
}