class FollowRequest {
  final int? userId;
  final int? eventId;
  const FollowRequest({this.userId, this.eventId});

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'event_id': eventId
    };
  }
}