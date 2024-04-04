import 'package:dio/dio.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/core/usecase/usecase.dart';
import 'package:ku_noti/features/data/event/models/follow_event_request.dart';
import 'package:ku_noti/features/domain/event/repositories/event_repository.dart';


class FollowEventUseCase implements UseCase<DataState<void>, FollowRequest> {
  final EventRepository _eventRepository;
  FollowEventUseCase(this._eventRepository);

  @override
  Future<DataState<void>> call({FollowRequest? params}) {
    if (params == null) {
      return Future(() => DataFailed(
          DioException(
              requestOptions: RequestOptions(
                  data: "request is null"
              )
          )
      ));
    }

    return _eventRepository.followEvent(params);
  }
}