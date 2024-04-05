import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/core/constants/constants.dart';
import 'package:ku_noti/core/format_date_string.dart';
import 'package:ku_noti/features/data/event/models/follow_event_request.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_state.dart';
import 'package:ku_noti/features/presentation/event/pages/event_detail_page.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';

class EventPopularCard extends StatelessWidget {
  EventEntity? event;
  EventPopularCard({
    super.key,
    this.event
  });

  // bool isFollowed = false;
  void _navigateToCardDetailPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailPage(event: event),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FollowEventBloc, FollowEventState>(
      listener: (context, state) {
        if (state is FollowEventError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Error occurred')));
        }
      },
      child: BlocBuilder<FollowEventBloc, FollowEventState>(
        builder: (context, state) {
          bool? isFollowed = false;
          if (state is FollowedEventsLoaded) {
            isFollowed = state.followedEventIds?.contains(event?.id.toString());
          }

          // Build your widget based on the state
          return GestureDetector(
              onTap: () => _navigateToCardDetailPage(context),
              child: _buildCard(context, isFollowed!) // Ensure _buildCard uses isFollowed to decide the icon
          );
        },
      ),
    );
  }

  void onTap(BuildContext context) {
    final userId = context.read<AuthBloc>().state.user?.userId;
    if (userId == null) return; // Handle not logged in user

    final currentState = context.read<FollowEventBloc>().state;
    if (currentState is FollowedEventsLoaded) {
      final isCurrentlyFollowed = currentState.followedEventIds?.contains(event?.id.toString());
      final followRequest = FollowRequest(userId: userId, eventId: event?.id);

      if (isCurrentlyFollowed!) {
        context.read<FollowEventBloc>().add(UnFollowEventPressed(followRequest));
        context.read<FollowEventBloc>().add((LoadFollowedEvents(userId)));
      } else {
        context.read<FollowEventBloc>().add(FollowEventPressed(followRequest));
        // context.read<FollowEventBloc>().add((LoadFollowedEvents(userId)));
      }
    }
  }

  Widget _buildCard(BuildContext context, bool isFollowed) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              event?.image != null && event!.image!.isNotEmpty
              ? event!.image!
              : kDefaultImage,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event?.title ?? 'Event Title',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(event?.startDateTime ?? DateTime.now()),
                  style: TextStyle(fontSize: 12, color: MyColors().primary),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: MyColors().primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                          event?.locationName ?? 'location name', // Replace with your event location
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        onTap(context);
                      },
                      child: Icon(
                        isFollowed ? Icons.favorite : Icons.favorite_border,
                        color: MyColors().primary,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
