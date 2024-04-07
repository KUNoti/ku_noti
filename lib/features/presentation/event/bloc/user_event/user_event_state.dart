
import 'package:equatable/equatable.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';

abstract class UserEventsState extends Equatable {
  final List<EventEntity> ? events;
  final String? errorMessage;

  const UserEventsState({this.events, this.errorMessage});

  @override
  List<Object?> get props => [events, errorMessage];
}

class UserEventsInitail extends UserEventsState {
  const UserEventsInitail();
}

class UserEventsLoading extends UserEventsState {
  const UserEventsLoading();
}

class UserEventsSuccess extends UserEventsState {
  const UserEventsSuccess(
      List<EventEntity>? events,
      ) : super(events: events);
}

class UserEventsError extends UserEventsState {
  const UserEventsError(String errorMessage) : super(errorMessage: errorMessage);
}

class LoadTagSuccess extends UserEventsState {
  final List<String> tags;
  const LoadTagSuccess(this.tags);
}

class FollowTagSuccess extends UserEventsState {
  final String message;
  const FollowTagSuccess(this.message);
}