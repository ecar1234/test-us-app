

import 'package:flutter/cupertino.dart';

class DataEvent {}

class RequestUserInfoEvent extends DataEvent {
  BuildContext context;
  RequestUserInfoEvent(this.context);
}

class RequestPostDataEvent extends DataEvent {
  BuildContext context;
  RequestPostDataEvent(this.context);
}