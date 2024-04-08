
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/domain/event/usecases/follow_tag_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/get_create_by_me_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/get_register_event_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/get_tag_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/unfollow_tag_usecase.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_state.dart';

class UserEventBloc extends Bloc<UserEventsEvent, UserEventsState> {
  final GetCreateByMeUseCase _createByMeUseCase;
  final GetTagUseCase _getTagUseCase;
  final FollowTagUseCase _followTagUseCase;
  final UnFollowTagUseCase _unFollowTagUseCase;
  final GetRegisterEventUseCase _getRegisterEventUseCase;
  // final Get

  UserEventBloc(
      this._createByMeUseCase,
      this._getTagUseCase,
      this._followTagUseCase,
      this._unFollowTagUseCase,
      this._getRegisterEventUseCase,
      ): super(const UserEventsInitail()
  ) {
    on <LoadUserEventsEvent> (_onLoadUserEvent);
    on <LoadUserRegisterEvent> (_onLoadRegister);
    on <LoadTag> (_onLoadTag);
    on <FollowTagPressed> (_onFollowTagPressed);
    on <UnFollowTagPressed> (_onUnFollowTagPressed);
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

  FutureOr<void> _onLoadTag(LoadTag event, Emitter<UserEventsState> emit) async{
    final result = await _getTagUseCase(params: event.token);
    if (result is DataSuccess<List<String>>) {
      emit(LoadTagSuccess(result.data!));
    } else if (result is DataFailed) {
      emit(const UserEventsError("failed to follow"));
    }
  }

  FutureOr<void> _onFollowTagPressed(FollowTagPressed event, Emitter<UserEventsState> emit) async{
    final result = await _followTagUseCase(params: event.request);
    if (result is DataSuccess<String>) {
      emit(FollowTagSuccess(result.data!));
    } else if (result is DataFailed) {
      emit(const UserEventsError("failed to follow"));
    }
  }

  FutureOr<void> _onUnFollowTagPressed(UnFollowTagPressed event, Emitter<UserEventsState> emit) async{
    final result = await _unFollowTagUseCase(params: event.request);
    if (result is DataSuccess<String>) {
      emit(FollowTagSuccess(result.data!));
    } else if (result is DataFailed) {
      emit(const UserEventsError("failed to follow"));
    }
  }



  FutureOr<void> _onLoadRegister(LoadUserRegisterEvent event, Emitter<UserEventsState> emit) async{
    final result = await _getRegisterEventUseCase(params: event.userId);
    if (result is DataSuccess<List<EventEntity>>) {
      emit(RegistrationSuccess(result.data!));
    } else if (result is DataFailed) {
      emit(const UserEventsError("failed to follow"));
    }
  }
}