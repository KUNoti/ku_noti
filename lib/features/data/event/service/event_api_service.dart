

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ku_noti/core/constants/constants.dart';
import 'package:ku_noti/features/data/event/models/event.dart';
import 'package:ku_noti/features/data/event/models/follow_event_request.dart';
import 'package:ku_noti/features/data/event/models/follow_tag_request.dart';
import 'package:retrofit/retrofit.dart';
part 'event_api_service.g.dart';

@RestApi(baseUrl: APIBaseIOSURL)
abstract class EventApiService {
  factory EventApiService(Dio dio) = _EventApiService;

  @GET('/api/event/events')
  Future<HttpResponse<List<EventModel>>> getEvents();

  @POST('/api/event/create')
  @MultiPart()
  Future<HttpResponse<void>> createEvent(
      @Part(name: "title") String title,
      @Part(name: "latitude") num latitude,
      @Part(name: "longitude") num longitude,
      @Part(name: "start_date_time") String stateDate,
      @Part(name: "end_date_time") String endDate,
      @Part(name: "price") num price,
      @Part(name: "creator") int creator,
      @Part(name: "detail") String detail,
      @Part(name: "location_name") String locationName,
      @Part(name: "need_regis") bool needRegis,
      @Part(name: "image_file") File imageFile,
      @Part(name: "tag") String tag,
      );

  @GET('/api/event/follow_events')
  Future<HttpResponse<List<EventModel>>> getFollowEvent(
      @Field("user_id") int userId
  );

  @POST('/api/event/follow')
  Future<HttpResponse<void>> followEvent(
    @Body() FollowRequest request
  );

  @DELETE('/api/event/unfollow')
  Future<HttpResponse<void>> unFollowEvent(
    @Body() FollowRequest request
  );
  
  @GET('/api/event/created_by_me')
  Future<HttpResponse<List<EventModel>>> getCreateByMe(
    @Field("user_id") int userId
  );

  @GET('/api/event/tag')
  Future<HttpResponse<List<String>>> getTags(
    @Field("token") String token
  );

  @POST('/api/event/follow_tag')
  Future<HttpResponse<String>> followTag(
      @Body() FollowTagRequest request
  );

  @DELETE('/api/event/unfollow_tag')
  Future<HttpResponse<String>> unFollowTag(
      @Body() FollowTagRequest request
  );
}