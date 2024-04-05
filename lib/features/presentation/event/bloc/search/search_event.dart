

abstract class SearchEvent {
  const SearchEvent();
}

class LoadEventEvent extends SearchEvent {
  final int? userId;
  const LoadEventEvent(this.userId);
}

class FilterByTagEvent extends SearchEvent {
  final String tag;
  const FilterByTagEvent(this.tag);
}
