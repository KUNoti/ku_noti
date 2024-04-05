
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/core/constants/constants.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/events_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_state.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_state.dart';
import 'package:ku_noti/features/presentation/event/pages/search_page.dart';
import 'package:ku_noti/features/presentation/event/widgets/event_big_card.dart';
import 'package:ku_noti/features/presentation/event/widgets/event_popular_card.dart';
import 'package:ku_noti/features/presentation/event/widgets/select_chips.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_state.dart';

class HomePage extends StatefulWidget {

  const HomePage({
    super.key,

  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedChipIndex = 0;

  void navigationToSearchPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SearchPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSearchBarButton(context),
              _buildFeaturedSection(context),
               const SizedBox(height: 16),
              _buildPopularSection(context)
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String name = 'Guest';
          String imagePath = kDefaultImage;

          if (state is AuthDone && state.user != null) {
            name = state.user!.name!;
            imagePath = state.user!.imagePath!;
          }

          // Build the AppBar with user info
          return AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 10,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imagePath),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Good Morning 👋',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                  // Action for the button press
                },
              ),
              const SizedBox(width: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is EventsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventsError) {
            return Center(
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<EventsBloc>().add(const GetEvents());
                },
              ),
            );
          } else if (state is EventSuccess) {
            return Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        navigationToSearchPage(context);
                      },
                      child: Text('See All',style: TextStyle(color: MyColors().primary),),
                    ),
                  ],
                ),
              ),
              _buildFeaturedEventList(context, state.events)
            ]);
          } else {
            return const SizedBox();
          }
        }
    );
  }

  Widget _buildFeaturedEventList(BuildContext context, List<EventEntity>? events) {
    return SizedBox(
      height: 350,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events?.length ?? 0,
        itemBuilder: (context, index) {
          final event = events![index];
          return BlocListener<FollowEventBloc, FollowEventState>(
            listener: (context, state) {
              if (state is FollowEventSuccess) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Followed successfully!')),
                // );
              } else if (state is FollowEventError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage ?? 'Error following')),
                );
              }
            },
            child: EventBigCard(event: event)
          );
        }
      ),
    );
  }

  Widget _buildPopularSection(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is EventsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventsError) {
            return Center(
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<EventsBloc>().add(const GetEvents());
                },
              ),
            );
          } else if (state is EventSuccess) {
            return _buildPopularSectionGridWrapper(context, state.events);
          } else {
            return const SizedBox();
          }
        }
    );
  }

  Widget _buildPopularSectionGridWrapper(BuildContext context, List<EventEntity>? events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Popular Event 🔥', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

              GestureDetector(
                onTap: () {
                  navigationToSearchPage(context);
                },
                child: Text('See All', style: TextStyle(color: MyColors().primary))
              ),
            ],
          ),
        ),

        SelectChips(
            selectedChipIndex: selectedChipIndex,
            onChipSelected: (String selectedLabel, int index) {
              setState(() {
                selectedChipIndex = index;
              });
            }
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6, // for example, 60% of the screen height
          child: _buildPopularEventList(context, events),
        ),
      ],
    );
  }

  Widget _buildPopularEventList(BuildContext context, List<EventEntity>? events) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: events?.length,
      itemBuilder: (context, index) {
        final event = events![index];
        return EventPopularCard(event: event);
      },
    );
  }

  Widget _buildSearchBarButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigationToSearchPage(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: const EdgeInsets.all(16.0),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'What event are you looking for...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
            ),
            Icon(Icons.tune, color: MyColors().primary),
          ],
        ),
      ),
    );
  }
}

