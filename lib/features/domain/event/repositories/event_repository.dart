
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/data/event/models/follow_event_request.dart';
import 'package:ku_noti/features/data/event/models/follow_tag_request.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';

abstract class EventRepository {
  Future<DataState<List<EventEntity>>> getEvents();
  Future<DataState<void>> createEvent(EventEntity event);

  Future<DataState<List<EventEntity>>> getFollowEvent(int userId);
  Future<DataState<void>> followEvent(FollowRequest request);
  Future<DataState<void>> unFollowEvent(FollowRequest request);

  Future<DataState<List<EventEntity>>> getCreateByMe(int userId);

  // Follow Tag
  Future<DataState<List<String>>> getTag(String token);
  Future<DataState<String>> followTag(FollowTagRequest request);
  Future<DataState<String>> unFollowTag(FollowTagRequest request);
}