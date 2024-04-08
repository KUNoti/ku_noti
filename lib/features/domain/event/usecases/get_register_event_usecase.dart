

import 'package:dio/dio.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/core/usecase/usecase.dart';
import 'package:ku_noti/features/domain/event/repositories/event_repository.dart';


class GetRegisterEventUseCase implements UseCase<DataState<void>, int>{
  final EventRepository _eventRepository;
  GetRegisterEventUseCase(this._eventRepository);

  @override
  Future<DataState<void>> call({int? params}) {
    if (params == null) {
      return Future(() => DataFailed(
          DioException(
              requestOptions: RequestOptions(
                  data: "request is null"
              )
          )
      ));
    }

    return _eventRepository.getRegister(params);
  }
}
