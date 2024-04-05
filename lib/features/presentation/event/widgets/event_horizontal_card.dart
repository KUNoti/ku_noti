import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/core/constants/constants.dart';
import 'package:ku_noti/core/format_date_string.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_state.dart';

import 'event_card_base.dart';

class EventHorizCard extends EventCardBase {
  const EventHorizCard({
    super.key,
    super.event
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<FollowEventBloc, FollowEventState>(
      listener: (context, state) {
        // Listen for specific state changes you want to react to
        if (state is FollowEventError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Error occurred')));
        }
      },
      child: BlocBuilder<FollowEventBloc, FollowEventState>(
        builder: (context, state) {
          bool? isFollowed = false;
          if (state is FollowEventSuccess) {
            isFollowed = state.followedEventIds?.contains(event?.id.toString());
          }

          // Build your widget based on the state
          return GestureDetector(
              onTap: () => navigateToCardDetailPage(context),
              child: _buildCard(context, isFollowed!) // Ensure _buildCard uses isFollowed to decide the icon
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, bool isFollowed) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding around the Row for better spacing
        child: Row(
          mainAxisSize: MainAxisSize.min, // Ensure Row takes up only necessary space
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              child: Image.network(
                event?.image ?? kDefaultImage,
                fit: BoxFit.cover,
                height: 120,
                width: 120,
              ),
            ),
            const SizedBox(width: 8), // Add some spacing between the image and the text
            Expanded( // Wrap Column in an Expanded widget
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event?.title ?? 'Event title',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatDate(event?.startDateTime ?? DateTime.now()),
                    style: TextStyle(color: MyColors().primary, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: MyColors().primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded( // Wrap Text in an Expanded widget to ensure it fits within the available space
                        child: Text(
                          event?.locationName ?? 'location name',
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          handleTap(context);
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
      ),
    );
  }
}




