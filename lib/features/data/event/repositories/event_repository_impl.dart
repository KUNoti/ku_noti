
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/features/data/event/models/event.dart';
import 'package:ku_noti/features/data/event/models/follow_event_request.dart';
import 'package:ku_noti/features/data/event/models/follow_tag_request.dart';
import 'package:ku_noti/features/data/event/service/event_api_service.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/domain/event/repositories/event_repository.dart';
import 'package:ku_noti/features/domain/event/usecases/register_event_usecase.dart';

class EventRepositoryImpl implements EventRepository {
  final EventApiService _eventApiService;
  EventRepositoryImpl(this._eventApiService);

  @override
  Future<DataState<List<EventModel>>> getEvents() async {
    try {
      final httpResponse = await _eventApiService.getEvents();

      if(httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess<List<EventModel>>(httpResponse.data);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> createEvent(EventEntity event) async {
    try {
      EventModel eventModel = EventModel.fromEntity(event);
      final httpResponse = await _eventApiService.createEvent(
          eventModel.title!,
          eventModel.latitude!,
          eventModel.longitude!,
          "${eventModel.startDateTime!.toIso8601String()}Z",
          "${eventModel.endDateTime!.toIso8601String()}Z",
          eventModel.price!,
          eventModel.creator!,
          eventModel.detail!,
          eventModel.locationName!,
          eventModel.needRegis!,
          eventModel.imageFile!,
          eventModel.tag!
      );

      if(httpResponse.response.statusCode == HttpStatus.ok) {
        return const DataSuccess<void>(null);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> followEvent(FollowRequest request) async {
    try {
      final httpResponse = await _eventApiService.followEvent(request);
      if(httpResponse.response.statusCode == HttpStatus.ok) {
        return const DataSuccess<void>(null);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> unFollowEvent(FollowRequest request) async {
    try {
      final httpResponse = await _eventApiService.unFollowEvent(request);
      if(httpResponse.response.statusCode == HttpStatus.ok) {
        return const DataSuccess<void>(null);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<EventModel>>> getFollowEvent(int userId) async{
    try {
      final httpResponse = await _eventApiService.getFollowEvent(userId);
      if(httpResponse.response.statusCode == HttpStatus.ok) {
        return  DataSuccess<List<EventModel>>(httpResponse.data);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<EventEntity>>> getCreateByMe(int userId) async{
    try {
      final httpResponse = await _eventApiService.getCreateByMe(userId);
      if(httpResponse.response.statusCode == HttpStatus.ok) {
        return  DataSuccess<List<EventModel>>(httpResponse.data);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<String>> followTag(FollowTagRequest request) async{
    try {
      final httpResponse = await _eventApiService.followTag(request);
      if(httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess<String>(httpResponse.data);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<String>> unFollowTag(FollowTagRequest request) async{
    try {
      final httpResponse = await _eventApiService.unFollowTag(request);
      if(httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess<String>(httpResponse.data);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<String>>> getTag(String token) async{
    try {
      final httpResponse = await _eventApiService.getTags(token);
      if(httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess<List<String>>(httpResponse.data);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<EventEntity>>> getRegister(int userId) async{
    try {
      final httpResponse = await _eventApiService.getRegister(userId);
      if(httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess<List<EventEntity>>(httpResponse.data);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> registerEvent(RegisterEventRequest request) async {
    try {
      final httpResponse = await _eventApiService.registerEvent(request);
      if(httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess<List<EventEntity>>(httpResponse.data);
      } else {
        return DataFailed(
            DioException(
                error: httpResponse.response.statusMessage,
                response: httpResponse.response,
                type: DioExceptionType.badResponse,
                requestOptions: httpResponse.response.requestOptions
            )
        );
      }
    } on DioException catch(e) {
      return DataFailed(e);
    }
  }
}
