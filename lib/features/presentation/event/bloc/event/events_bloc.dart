
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/domain/event/usecases/create_event_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/get_events_usecase.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_state.dart';


class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEventsUseCase _getEventUseCase;
  final CreateEventUseCase _createEventUseCase;

  EventsBloc(
      this._getEventUseCase,
      this._createEventUseCase
      ) : super(const EventsInitail()
  ) {
    on <GetEvents> (_onGetEvents);
    on <CreateEvent> (_onCreateEvent);
    on <FilterByTagEvent> (_onFilterByTag);
    on <SearchByKeyWordEvent> (_onSearchByKeyWordEvent);
  }

  void _onGetEvents(GetEvents event, Emitter<EventsState> emit) async {
    emit(const EventsLoading());
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

  void _onCreateEvent(CreateEvent event, Emitter<EventsState> emit) async {
    emit(const EventsLoading());
    try {
      final dataState = await _createEventUseCase(params: event.eventEntity);

      if (dataState is DataSuccess) {

        final getEventsState = await _getEventUseCase();
        if (getEventsState is DataSuccess && getEventsState.data!.isNotEmpty) {
          emit(EventSuccess(getEventsState.data!));
        }

        emit(const EventSuccess([]));
      }

      if (dataState is DataFailed) {
        emit(const EventsError("failed to create event"));
      }

    } catch (e) {
      if (kDebugMode) {
        print("failed to create event $e");
      }
    }
  }

  void _onFilterByTag(FilterByTagEvent event, Emitter<EventsState> emit) {
    if (state is EventSuccess) {
      List<EventEntity> allEvents = List.from((state as EventSuccess).events!);
      allEvents.sort((a, b) {
        if (a.tag == event.tag && b.tag != event.tag) return -1; // a comes first
        if (a.tag != event.tag && b.tag == event.tag) return 1;  // b comes first
        return 0; // No change
      });

      emit(EventSuccess(allEvents));
    }
  }

  void _onSearchByKeyWordEvent(SearchByKeyWordEvent searchEvent, Emitter<EventsState> emit) {
    if (state is EventSuccess) {
      List<EventEntity> allEvents = List.from((state as EventSuccess).events!);

      String searchLowercase = searchEvent.keyword.toLowerCase();
      allEvents.sort((a, b) {
        int scoreA = (a.title?.toLowerCase().contains(searchLowercase) ?? false ? 3 : 0) +
            (a.detail?.toLowerCase().contains(searchLowercase) ?? false ? 2 : 0) +
            (a.tag?.toLowerCase().contains(searchLowercase) ?? false ? 1 : 0);
        int scoreB = (b.title?.toLowerCase().contains(searchLowercase) ?? false ? 3 : 0) +
            (b.detail?.toLowerCase().contains(searchLowercase) ?? false ? 2 : 0) +
            (b.tag?.toLowerCase().contains(searchLowercase) ?? false ? 1 : 0);
        return scoreB.compareTo(scoreA);  // Descending sort by score
      });

      emit(EventSuccess(List.from(allEvents)));
    }
  }
}