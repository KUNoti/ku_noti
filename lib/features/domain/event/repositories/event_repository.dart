
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/data/event/models/follow_event_request.dart';
import 'package:ku_noti/features/data/event/models/follow_tag_request.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/domain/event/usecases/register_event_usecase.dart';

abstract class EventRepository {
  Future<DataState<List<EventEntity>>> getEvents();
  Future<DataState<void>> createEvent(EventEntity event);

  Future<DataState<List<EventEntity>>> getFollowEvent(int userId);
  Future<DataState<void>> followEvent(FollowRequest request);
  Future<DataState<void>> unFollowEvent(FollowRequest request);


  // Follow Tag
  Future<DataState<List<String>>> getTag(String token);
  Future<DataState<String>> followTag(FollowTagRequest request);
  Future<DataState<String>> unFollowTag(FollowTagRequest request);

  // Register
  Future<DataState<List<EventEntity>>> getCreateByMe(int userId);
  Future<DataState<List<EventEntity>>> getRegister(int userId);
  Future<DataState<void>> registerEvent(RegisterEventRequest request);
}