import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/domain/event/usecases/get_events_usecase.dart';
import 'package:ku_noti/features/domain/event/usecases/create_event_usecase.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/events_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_state.dart';

import 'events_bloc_test.mocks.dart';

@GenerateMocks([GetEventsUseCase, CreateEventUseCase])

void main() {
  group('EventsBloc Tests', () {
    late MockGetEventsUseCase mockGetEventsUseCase;
    late MockCreateEventUseCase mockCreateEventUseCase;
    late EventsBloc eventsBloc;

    setUp(() {
      mockGetEventsUseCase = MockGetEventsUseCase();
      mockCreateEventUseCase = MockCreateEventUseCase();
      eventsBloc = EventsBloc(mockGetEventsUseCase, mockCreateEventUseCase);
    });

    // Testing the loading of events
    blocTest<EventsBloc, EventsState>(
        'emits [EventsLoading, EventSuccess] when GetEvents is added',
        build: () => eventsBloc,
        act: (bloc) {
          when(mockGetEventsUseCase()).thenAnswer((_) async => const DataSuccess([EventEntity(id: 1, title: "Event 1")]));
          bloc.add(const GetEvents());
        },
        expect: () => [
          const EventsLoading(),
          isA<EventSuccess>().having((s) => s.events, 'events', isNotEmpty),
        ]
    );

    // Testing the creation of an event
    blocTest<EventsBloc, EventsState>(
        'emits [EventsLoading, EventSuccess, EventSuccess] when CreateEvent is added',
        build: () => eventsBloc,
        act: (bloc) {
          when(mockCreateEventUseCase(params: anyNamed('params')))
              .thenAnswer((_) async => const DataSuccess(null));
          when(mockGetEventsUseCase())
              .thenAnswer((_) async => const DataSuccess([EventEntity(id: 1, title: "Event 1"), EventEntity(id: 2, title: "Event 2")]));
          bloc.add(const CreateEvent(EventEntity(id: 2, title: "Event 2")));
        },
        expect: () => [
          const EventsLoading(),
          isA<EventSuccess>().having((s) => s.events, 'events', hasLength(2)),
          isA<EventSuccess>().having((s) => s.events, 'events', isEmpty),
        ]
    );

    // More tests can be added here for FilterByTagEvent and SearchByKeyWordEvent

    tearDown(() {
      eventsBloc.close();
    });
  });
}
