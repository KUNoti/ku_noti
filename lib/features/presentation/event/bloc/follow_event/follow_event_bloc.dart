
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/domain/event/usecases/follow_event_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/unfollow_event_usecase.dart';

import 'follow_event_event.dart';
import 'follow_event_state.dart';

class FollowEventBloc extends Bloc<FollowEventEvent, FollowEventState> {
  final FollowEventUseCase _followEventUseCase;
  final UnFollowEventUseCase _unFollowEventUseCase;

  FollowEventBloc(
      this._followEventUseCase,
      this._unFollowEventUseCase
      ): super(const FollowEventInitial()
  ) {
    on <FollowEventPressed> (_onFollowEvent);
    on <UnFollowEventPressed> (_onUnFollowEvent);
  }

  void _onFollowEvent(FollowEventPressed event, Emitter<FollowEventState> emit) async {
    emit(const FollowEventLoading());
    try {
      final dataState = await _followEventUseCase(params: event.request);
      if (dataState is DataSuccess) {
        emit(const FollowEventSuccess());
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
    try {
      final dataState = await _unFollowEventUseCase(params: event.request);
      if (dataState is DataSuccess) {
        emit(const UnFollowEventSuccess());
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
