
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/core/constants/constants.dart';
import 'package:ku_noti/core/format_date_string.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_state.dart';
import 'package:ku_noti/features/presentation/event/widgets/event_card_base.dart';

class EventPopularCard extends EventCardBase {
  const EventPopularCard({
    super.key,
    super.event
  });


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
    );
  }
}
