
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/domain/event/usecases/follow_event_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/get_follow_event_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/unfollow_event_usecase.dart';

import 'follow_event_event.dart';
import 'follow_event_state.dart';

class FollowEventBloc extends Bloc<FollowEventEvent, FollowEventState> {
  final FollowEventUseCase _followEventUseCase;
  final UnFollowEventUseCase _unFollowEventUseCase;
  final GetFollowEventUseCase _getFollowEventUseCase;
  final Set<String> _followedEventIds = {};

  FollowEventBloc(
      this._followEventUseCase,
      this._unFollowEventUseCase,
      this._getFollowEventUseCase
      ): super(const FollowEventInitial()
  ) {
    on <FollowEventPressed> (_onFollowEvent);
    on <UnFollowEventPressed> (_onUnFollowEvent);
    on <LoadFollowedEvents> (_onLoadFollowedEvents);
  }

  void _onLoadFollowedEvents(LoadFollowedEvents event, Emitter<FollowEventState> emit) async {
    emit(const FollowEventLoading());
    try {
      final dataState = await _getFollowEventUseCase(params: event.userId);
      if (dataState is DataSuccess) {
        _followedEventIds.clear();
        _followedEventIds.addAll(dataState.data!.map((e) => e.id.toString()));
        emit(FollowedEventsLoaded(_followedEventIds, dataState.data!));
      }
    } catch (e) {
      emit(FollowEventError(e.toString()));
      if (kDebugMode) {
        print("failed to follow event $e");
      }
    }
  }

  void _onFollowEvent(FollowEventPressed event, Emitter<FollowEventState> emit) async {
    emit(const FollowEventLoading());
    try {
      final dataState = await _followEventUseCase(params: event.request);
      if (dataState is DataSuccess) {
        _followedEventIds.add(event.request.eventId.toString()); // Ensure ID format consistency
        emit(FollowedEventsLoaded(_followedEventIds, null)); // Just emit the updated list
        // emit(const FollowEventSuccess());
      }

      if (dataState is DataFailed) {
        emit(FollowEventError(dataState.error.toString()));
      }

    } catch (e) {
      emit(FollowEventError(e.toString()));
      if (kDebugMode) {
        print("failed to follow event $e");
      }
    }
  }

  void _onUnFollowEvent(UnFollowEventPressed event, Emitter<FollowEventState> emit) async{
    emit(const FollowEventLoading());
    try {
      final dataState = await _unFollowEventUseCase(params: event.request);
      if (dataState is DataSuccess) {
        _followedEventIds.remove(event.request.eventId.toString());
        emit(FollowedEventsLoaded(_followedEventIds, null));
        // emit(const UnFollowEventSuccess());
      }

      if (dataState is DataFailed) {
        emit(UnFollowEventError(dataState.error.toString()));
      }

    } catch (e) {
      emit(UnFollowEventError(e.toString()));
      if (kDebugMode) {
        print("failed to follow event $e");
      }
    }
  }
}
