
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/domain/event/usecases/get_events_usecase.dart';
import 'package:ku_noti/features/presentation/event/bloc/remote_event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/remote_event_state.dart';

class RemoteEventsBloc extends Bloc<RemoteEventsEvent, RemoteEventsState> {
  final GetEventsUseCase _getEventUseCase;

  RemoteEventsBloc(
      this._getEventUseCase,
      // this._createEventUseCase,
      // this._followEventUseCase,
      // this._unFollowEventUseCase
      ) : super(const RemoteEventsLoading()
  ) {
    on <GetEvents> (onGetEvents);
    // on <CreateEvent> (onCreateEvent);
    // on <FollowEvent> (onFollowEvent);
    // on <UnFollowEvent> (onUnFollowEvent);
  }

  void onGetEvents(GetEvents event, Emitter<RemoteEventsState> emit) async {
    try {
      final dataState = await _getEventUseCase();

      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        emit(
            RemoteEventsDone(dataState.data!)
        );
      }

      if (dataState is DataFailed) {
        emit(
            RemoteEventsError(dataState.error!)
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("failed to get event $e");
      }
    }
  }
}