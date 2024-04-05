
import 'package:equatable/equatable.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';

abstract class EventsState extends Equatable {
  final List<EventEntity> ? events;
  final String? errorMessage;

  const EventsState({this.events, this.errorMessage});

  @override
  List<Object?> get props => [events, errorMessage];
}

class EventsInitail extends EventsState {
  const EventsInitail();
}

class EventsLoading extends EventsState {
  const EventsLoading();
}

class EventSuccess extends EventsState {
  const EventSuccess(
      List<EventEntity>? events,
  ) : super(events: events);
}

class EventsError extends EventsState {
  const EventsError(String errorMessage) : super(errorMessage: errorMessage);
}