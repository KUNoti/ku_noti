

import 'package:dio/dio.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/core/usecase/usecase.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/domain/event/repositories/event_repository.dart';

class GetFollowEventUseCase implements UseCase<DataState<List<EventEntity>>, int>{
  final EventRepository _eventRepository;
  GetFollowEventUseCase(this._eventRepository);

  @override
  Future<DataState<List<EventEntity>>> call({int? params}) {
    if (params == null) {
      return Future(() => DataFailed(
        DioException(
          requestOptions: RequestOptions(
            data: "request is null"
          )
        )
      ));
    }

    return _eventRepository.getFollowEvent(params);
  }
}