import 'package:flutter/material.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/core/constants/constants.dart';
import 'package:ku_noti/core/format_date_string.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';

class EventPopularCard extends StatelessWidget {
  EventEntity? event;
  EventPopularCard({
    super.key,
    this.event
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }

  Widget _buildCard(BuildContext context) {
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
                    Icon(
                      Icons.favorite,
                      color: MyColors().primary,
                      size: 16,
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
