
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/domain/event/entities/event_entity.dart';

abstract class EventRepository {
  Future<DataState<List<EventEntity>>> getEvents();

  // Future<DataState<void>> createEvent(EventEntity event);
  // Future<DataState<void>> followEvent(FollowRequest request);
  // Future<DataState<void>> unFollowEvent(FollowRequest request);

}