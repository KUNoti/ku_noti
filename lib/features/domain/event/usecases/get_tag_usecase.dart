
import 'package:dio/dio.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/core/usecase/usecase.dart';
import 'package:ku_noti/features/domain/event/repositories/event_repository.dart';

class GetTagUseCase implements UseCase<DataState<List<String>>, String> {
  final EventRepository _eventRepository;
  GetTagUseCase(this._eventRepository);

  @override
  Future<DataState<List<String>>> call({String? params}) {
    if (params == null) {
      return Future(() => DataFailed(
          DioException(
              requestOptions: RequestOptions(
                  data: "request is null"
              )
          )
      ));
    }

    return _eventRepository.getTag(params);
  }
}