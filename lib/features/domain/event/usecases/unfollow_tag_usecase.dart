
import 'package:dio/dio.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/core/usecase/usecase.dart';
import 'package:ku_noti/features/data/event/models/follow_tag_request.dart';
import 'package:ku_noti/features/domain/event/repositories/event_repository.dart';

class UnFollowTagUseCase implements UseCase<DataState<String>, FollowTagRequest> {
  final EventRepository _eventRepository;
  UnFollowTagUseCase(this._eventRepository);

  @override
  Future<DataState<String>> call({FollowTagRequest? params}) {
    if (params == null) {
      return Future(() => DataFailed(
          DioException(
              requestOptions: RequestOptions(
                  data: "request is null"
              )
          )
      ));
    }

    return _eventRepository.unFollowTag(params);
  }
}