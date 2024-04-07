
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/domain/event/usecases/get_create_by_me_usecase.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_state.dart';

class UserEventBloc extends Bloc<UserEventsEvent, UserEventsState> {
  final GetCreateByMeUseCase _createByMeUseCase;

  UserEventBloc(
      this._createByMeUseCase
      ): super(const UserEventsInitail()
  ) {
    on <LoadUserEventsEvent> (_onLoadUserEvent);
  }



  FutureOr<void> _onLoadUserEvent(LoadUserEventsEvent event, Emitter<UserEventsState> emit) async{
    emit(const UserEventsLoading());
    final dataState = await _createByMeUseCase(params: event.userId);
    if(dataState is DataSuccess<List<EventEntity>>) {
      emit(UserEventsSuccess(dataState.data));
    } else if (dataState is DataFailed) {
      emit(const UserEventsError("Failed to load event"));
    }
  }
}