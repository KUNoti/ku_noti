
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/domain/event/usecases/get_events_usecase.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_state.dart';


class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEventsUseCase _getEventUseCase;

  EventsBloc(
      this._getEventUseCase,
      ) : super(const EventsLoading()
  ) {
    on <GetEvents> (onGetEvents);
    // on <CreateEvent> (onCreateEvent);
  }

  void onGetEvents(GetEvents event, Emitter<EventsState> emit) async {
    try {
      final dataState = await _getEventUseCase();

      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        emit(
            EventSuccess(dataState.data!)
        );
      }

      if (dataState is DataFailed) {
        emit(
            const EventsError("Fetch Error error")
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("failed to get event $e");
      }
    }
  }
}