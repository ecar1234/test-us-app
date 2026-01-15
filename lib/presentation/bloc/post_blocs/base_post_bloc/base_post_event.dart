

class BasePostEvent {}

class ServiceStartEvent extends BasePostEvent {
  ServiceStartEvent();
}

class RequestInitDataEvent extends BasePostEvent {
  RequestInitDataEvent();
}
class RequestUserInItDataEvent extends BasePostEvent {
  String token;
  String userId;
  RequestUserInItDataEvent(this.token, this.userId);
}

class SearchPostEvent extends BasePostEvent {
  String keyword;
  SearchPostEvent(this.keyword);
}