
abstract class UserEventsEvent {
  const UserEventsEvent();
}

class LoadUserEventsEvent extends UserEventsEvent {
  final int? userId;
  const LoadUserEventsEvent(this.userId);
}

