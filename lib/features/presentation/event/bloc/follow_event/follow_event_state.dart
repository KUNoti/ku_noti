import 'package:equatable/equatable.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';

abstract class FollowEventState extends Equatable{
  final Set<String>? followedEventIds;
  final List<EventEntity>? followedEvents;
  final String? errorMessage;

  const FollowEventState({this.followedEventIds, this.followedEvents,this.errorMessage});

  @override
  List<Object?> get props => [followedEventIds, followedEvents, errorMessage];
}

class FollowEventInitial extends FollowEventState {
  const FollowEventInitial();
}

class FollowEventLoading extends FollowEventState {
  const FollowEventLoading();
}

class FollowEventError extends FollowEventState {
  const FollowEventError(String errorMessage) : super(errorMessage: errorMessage);
}

class UnFollowEventSuccess extends FollowEventState {
  const UnFollowEventSuccess();
}

class UnFollowEventError extends FollowEventState {
  const UnFollowEventError(String errorMessage) : super(errorMessage: errorMessage);
}

class FollowEventSuccess extends FollowEventState {
  const FollowEventSuccess(
    Set<String> followedEventIds,
    List<EventEntity>? followedEvents,
  ) : super(followedEventIds: followedEventIds , followedEvents: followedEvents);
}