import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';

class AppEvent{}

class RequestApplyEvent extends AppEvent {
  final BuildContext context;
  final String token;
  final ApplicationEntity app;
  RequestApplyEvent(this.context, this.token, this.app);
}

class RequestApplyUpdate extends AppEvent {
  final BuildContext context;
  final String token;
  final ApplicationEntity app;
  RequestApplyUpdate(this.context, this.token, this.app);
}

class RequestApplyCancelEvent extends AppEvent {
  BuildContext context;
  String token;
  int appId;
  RequestApplyCancelEvent(this.context, this.token, this.appId);
}

class ApplyRejectEvent extends AppEvent {}

class ApplyCompleteEvent extends AppEvent {}

class RequestUserApplicationsEvent extends AppEvent {
  BuildContext context;
  String token;
  String userId;
  RequestUserApplicationsEvent(this.context, this.token, this.userId);
}

class RequestCompletedEvent extends AppEvent {
  RequestCompletedEvent();
}
