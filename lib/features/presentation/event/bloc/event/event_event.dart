
import 'package:ku_noti/features/domain/event/entities/event.dart';

abstract class EventsEvent {
  const EventsEvent();
}

class GetEvents extends EventsEvent {
  const GetEvents();
}

class CreateEvent extends EventsEvent {
  final EventEntity eventEntity;
  const CreateEvent(this.eventEntity);
}

class FilterByTagEvent extends EventsEvent {
  final String tag;
  const FilterByTagEvent(this.tag);
}