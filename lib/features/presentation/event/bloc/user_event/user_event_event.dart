
import 'package:ku_noti/features/data/event/models/follow_tag_request.dart';

abstract class UserEventsEvent {
  const UserEventsEvent();
}

class LoadUserEventsEvent extends UserEventsEvent {
  final int? userId;
  const LoadUserEventsEvent(this.userId);
}

class LoadTag extends UserEventsEvent {
  final String? token;
  const LoadTag(this.token);
}

class LoadUserRegisterEvent extends UserEventsEvent {
  final int? userId;
  const LoadUserRegisterEvent(this.userId);
}

class FollowTagPressed extends UserEventsEvent {
  final FollowTagRequest request;
  const FollowTagPressed(this.request);
}

class UnFollowTagPressed extends UserEventsEvent {
  final FollowTagRequest request;
  const UnFollowTagPressed(this.request);
}

