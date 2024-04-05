import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/core/constants/constants.dart';
import 'package:ku_noti/core/format_date_string.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_state.dart';
import 'package:ku_noti/features/presentation/event/widgets/event_card_base.dart';

class EventBigCard extends EventCardBase {
  const EventBigCard({super.key, super.event});

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
              child: _buildCard(context, isFollowed) // Ensure _buildCard uses isFollowed to decide the icon
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, isFollowed) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Image.network(
              event?.image != null && event!.image!.isNotEmpty
                  ? event!.image!
                  : kDefaultImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event?.title ?? 'Event title',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDate(event?.startDateTime ?? DateTime.now()), // Replace with your event time
                      style:  TextStyle(color: MyColors().primary,fontWeight: FontWeight.bold, fontSize: 14),
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
                          Text(
                            event?.locationName ?? 'location name', // Replace with your event location
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              handleTap(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                isFollowed ? Icons.favorite : Icons.favorite_border,
                                color: MyColors().primary,
                                size: 24,
                              ),
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
