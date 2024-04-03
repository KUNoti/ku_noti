
import 'package:ku_noti/core/resources/data_state.dart';
import 'package:ku_noti/core/usecase/usecase.dart';
import 'package:ku_noti/features/domain/event/entities/event_entity.dart';
import 'package:ku_noti/features/domain/event/repositories/event_repository.dart';

class GetEventsUseCase implements UseCase<DataState<List<EventEntity>>, void>{
  final EventRepository _eventRepository;
  GetEventsUseCase(this._eventRepository);

  @override
  Future<DataState<List<EventEntity>>> call({void params}) {
    return _eventRepository.getEvents();
  }
}