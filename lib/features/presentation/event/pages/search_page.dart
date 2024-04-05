import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_state.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/events_bloc.dart';
import 'package:ku_noti/features/presentation/event/widgets/event_horizontal_card.dart';
import 'package:ku_noti/features/presentation/event/widgets/event_popular_card.dart';
import 'package:ku_noti/features/presentation/event/widgets/search_bar.dart';
import 'package:ku_noti/features/presentation/event/widgets/select_chips.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int selectedChipIndex = 0;
  bool isListView = true;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onSearchChanged();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // if (_controller.text.isEmpty!) {
      context.read<EventsBloc>().add(SearchByKeyWordEvent(_controller.text));
    // }
    print(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: MySearchBarWidget(
            _controller,
          ),
        )
    );
  }

  Widget _buildBody(BuildContext context, EventsState state) {
    int foundsCount = 0;
    if (state is EventSuccess) {
      foundsCount = state.events?.length ?? 0;
    }
    return Column(
      children: [
        SelectChips(
            selectedChipIndex: selectedChipIndex,
            onChipSelected: (String selectedLabel, int index) {
              setState(() {
                selectedChipIndex = index;
                context.read<EventsBloc>().add(FilterByTagEvent(selectedLabel));

              });
            }
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 12),
            Text("$foundsCount founds", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.document_scanner , size: 24, color: isListView ? MyColors().primary : Colors.grey),
                  onPressed: () {
                    setState(() {
                      isListView = !isListView;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.view_list, size: 24, color: isListView ? Colors.grey : MyColors().primary),
                  onPressed: () {
                    setState(() {
                      isListView = !isListView;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        isListView ? _buildEventList(context, state) : _buildGridEventList(context, state)
      ],
    );
  }

  Widget _buildEventList(BuildContext context, EventsState state) {
    if (state is EventsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is EventSuccess) {
      return Expanded(
        child: ListView.builder(
          itemCount: state.events?.length ?? 0,
          itemBuilder: (context, index) {
            final event = state.events?[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: EventHorizCard(event: event), // Assuming you have an EventHorizontalCard widget that takes an event object
            );
          },
        ),
      );
    } else if (state is EventsError) {
      return Center(child: Text(state.errorMessage ?? "Error loading events"));
    } else {
      return const Center(child: Text("No data available."));
    }
  }

  Widget _buildGridEventList(BuildContext context, EventsState state) {
    if (state is EventsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is EventSuccess) {
      return Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: state.events?.length,
            itemBuilder: (context, index) {
              final event = state.events![index];
              return EventPopularCard(event: event);
            },
          )
      );
    } else if (state is EventsError) {
      return Center(child: Text(state.errorMessage ?? "Error loading events"));
    } else {
      return const Center(child: Text("No data available."));
    }
  }
}
