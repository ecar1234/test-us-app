

import 'package:flutter/cupertino.dart';

import '../../../domain/entities/post_entity.dart';

class DataEvent {}

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

class RequestPostUpdateEvent extends DataEvent {
  BuildContext context;
  PostEntity post;
  String token;
  RequestPostUpdateEvent(this.context, this.token, this.post);
}
class RequestPostDeleteEvent extends DataEvent {
  BuildContext context;
  String postId;
  String token;
  RequestPostDeleteEvent(this.context, this.token, this.postId);
}

class RequestPostCreateEvent extends DataEvent {
  BuildContext context;
  PostEntity post;
  String token;
  RequestPostCreateEvent(this.context, this.post, this.token);
}

class RequestCompleteEvent extends DataEvent {
  RequestCompleteEvent();
}
