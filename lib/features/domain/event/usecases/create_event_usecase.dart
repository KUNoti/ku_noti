
import 'package:dio/dio.dart';
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/core/usecase/usecase.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/domain/event/repositories/event_repository.dart';

class CreateEventUseCase implements UseCase<DataState<void>, EventEntity> {
  final EventRepository _eventRepository;
  CreateEventUseCase(this._eventRepository);

  @override
  Future<DataState<void>> call({EventEntity? params}) {
    if (params == null) {
      return Future(() => DataFailed(
          DioException(
              requestOptions: RequestOptions(
                  data: "eventEntity is null"
              )
          )
      ));
    }

    return _eventRepository.createEvent(params);
  }
}