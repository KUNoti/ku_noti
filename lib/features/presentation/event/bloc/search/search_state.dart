
import 'package:equatable/equatable.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';

abstract class SearchState extends Equatable {
  final List<EventEntity>? events;
  final String? errorMessage;

  const SearchState({this.events, this.errorMessage});

  @override
  List<Object?> get props  => [events, errorMessage];
}

class SearchStateInitail extends SearchState {
  const SearchStateInitail();
}

class SearchStateLoading extends SearchState {
  const SearchStateLoading();
}

class SearchStateSuccess extends SearchState {
  const SearchStateSuccess(
      List<EventEntity> events,
  ): super(events: events);
}

class SearchStateError extends SearchState {
  const SearchStateError(String errorMessage) : super(errorMessage: errorMessage);
}