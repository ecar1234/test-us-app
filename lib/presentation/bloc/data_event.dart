

import 'package:flutter/cupertino.dart';

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
  String platform;
  int page;
  RequestPostDataEvent(this.context, this.platform, this.page);
}
