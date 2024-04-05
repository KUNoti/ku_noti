import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_state.dart';
import 'package:ku_noti/features/presentation/event/widgets/event_horizontal_card.dart';
import 'package:ku_noti/features/presentation/event/widgets/select_chips.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  int selectedChipIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: BlocBuilder<FollowEventBloc, FollowEventState>(
            builder: (context, state) {
              return _buildBody(context, state);
            },
          ),
        )
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Row(
            children: [
              const SizedBox(width: 16),
              Icon(Icons.favorite, color: MyColors().primary, size: 36),
            ],
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Favorites", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
            ],
          ),
        )
    );
  }

  Widget _buildBody(BuildContext context, FollowEventState state) {
    int favoritesCount = 0;
    if (state is FollowedEventsLoaded) {
      favoritesCount = state.followedEvents?.length ?? 0;
    }

    return Column(
      children: [
        SelectChips(
          selectedChipIndex: selectedChipIndex,
          onChipSelected: (String selectedLabel, int index) {
            setState(() {
              selectedChipIndex = index;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 16),
            Text("$favoritesCount Favorites", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        _buildEventList(context, state) // Pass the state to the _buildEventList method
      ],
    );
  }

  Widget _buildEventList(BuildContext context, FollowEventState state) {
    if (state is FollowEventLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is FollowedEventsLoaded) {
      return Expanded(
        child: ListView.builder(
          itemCount: state.followedEventIds?.length ?? 0,
          itemBuilder: (context, index) {
            final event = state.followedEvents?[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: EventHorizCard(event: event), // Assuming you have an EventHorizontalCard widget that takes an event object
            );
          },
        ),
      );
    } else if (state is FollowEventError) {
      return Center(child: Text(state.errorMessage ?? "Error loading events"));
    } else {
      return const Center(child: Text("No data available."));
    }
  }
}
