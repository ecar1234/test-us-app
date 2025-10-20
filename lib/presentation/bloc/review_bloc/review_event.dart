

class ReviewEvent {}

class RequestUserReviewEvent extends ReviewEvent {
  final String userId;
  final String token;
  RequestUserReviewEvent(this.token, this.userId);
}

class RequestUserReviewAverage extends ReviewEvent {
  final String userId;
  final String token;
  RequestUserReviewAverage(this.token, this.userId);
}

class RequestUsersReviewEvent extends ReviewEvent {
  final String token;
  final List<String> userIds;
  RequestUsersReviewEvent(this.token, this.userIds);
}