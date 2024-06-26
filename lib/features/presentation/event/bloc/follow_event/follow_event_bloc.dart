
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/domain/event/usecases/follow_event_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/get_follow_event_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/unfollow_event_usecase.dart';

import 'follow_event_event.dart';
import 'follow_event_state.dart';

class FollowEventBloc extends Bloc<FollowEventEvent, FollowEventState> {
  final FollowEventUseCase _followEventUseCase;
  final UnFollowEventUseCase _unFollowEventUseCase;
  final GetFollowEventUseCase _getFollowEventUseCase;

  FollowEventBloc(
      this._followEventUseCase,
      this._unFollowEventUseCase,
      this._getFollowEventUseCase
      ): super(const FollowEventInitial()
  ) {
    on <FollowEventPressed> (_onFollowEvent);
    on <UnFollowEventPressed> (_onUnFollowEvent);
    on <LoadFollowedEvents> (_onLoadFollowedEvents);
    on <FilterByTagEvent> (_onFilterByTag);
  }

  Future<void> _onFollowEvent(FollowEventPressed event, Emitter<FollowEventState> emit) async {
    emit(const FollowEventLoading());
    final result = await _followEventUseCase(params: event.request);
    if (result is DataSuccess<void>) {
      await _reloadFollowedEvents(event.request.userId!, emit);
    } else if (result is DataFailed) {
      emit(FollowEventError(result.error.toString()));
    }
  }

  Future<void> _onUnFollowEvent(UnFollowEventPressed event, Emitter<FollowEventState> emit) async {
    emit(const FollowEventLoading());
    final result = await _unFollowEventUseCase(params: event.request);
    if (result is DataSuccess<void>) {
      await _reloadFollowedEvents(event.request.userId!, emit);
    } else if (result is DataFailed) {
      emit(UnFollowEventError(result.error.toString()));
    }
  }

  Future<void> _onLoadFollowedEvents(LoadFollowedEvents event, Emitter<FollowEventState> emit) async {
    await _reloadFollowedEvents(event.userId!, emit); // Assuming userId should not be null here
  }

  Future<void> _reloadFollowedEvents(int userId, Emitter<FollowEventState> emit) async {
    emit(const FollowEventLoading());
    final dataState = await _getFollowEventUseCase(params: userId);
    if (dataState is DataSuccess<List<EventEntity>>) {
      final followedEventIds = dataState.data!.map((e) => e.id.toString()).toSet();
      emit(FollowEventSuccess(followedEventIds, dataState.data!));
    } else if (dataState is DataFailed) {
      emit(const FollowEventError("Failed to reload followed events."));
    }
  }

  void _onFilterByTag(FilterByTagEvent event, Emitter<FollowEventState> emit) {
    if (state is FollowEventSuccess) {
      List<EventEntity> allEvents = List.from((state as FollowEventSuccess).followedEvents!);
      allEvents.sort((a, b) {
        if (a.tag == event.tag && b.tag != event.tag) return -1; // a comes first
        if (a.tag != event.tag && b.tag == event.tag) return 1;  // b comes first
        return 0; // No change
      });

      emit(FollowEventSuccess((state as FollowEventSuccess).followedEventIds!, allEvents));
    }
  }
}
