import 'package:ku_noti/features/data/event/models/follow_event_request.dart';

abstract class FollowEventEvent {
  const FollowEventEvent();
}

class FollowEventPressed extends FollowEventEvent {
  final FollowRequest request;
  const FollowEventPressed(this.request);
}

class UnFollowEventPressed extends FollowEventEvent {
  final FollowRequest request;
  const UnFollowEventPressed(this.request);
}