

import 'package:dio/dio.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/core/usecase/usecase.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/domain/event/repositories/event_repository.dart';

class RegisterEventRequest {
  final int? userId;
  final int? eventId;
  const RegisterEventRequest({this.userId, this.eventId});

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'event_id': eventId
    };
  }
}

class RegisterEventUseCase implements UseCase<DataState<void>,  RegisterEventRequest>{
  final EventRepository _eventRepository;
  RegisterEventUseCase(this._eventRepository);

  @override
  Future<DataState<void>> call({RegisterEventRequest? params}) {
    if (params == null) {
      return Future(() => DataFailed(
          DioException(
              requestOptions: RequestOptions(
                  data: "request is null"
              )
          )
      ));
    }

    return _eventRepository.registerEvent(params);
  }
}