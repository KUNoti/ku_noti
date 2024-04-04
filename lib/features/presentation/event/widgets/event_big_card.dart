import 'package:flutter/material.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/core/constants/constants.dart';
import 'package:ku_noti/core/format_date_string.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/presentation/event/pages/event_detail_page.dart';

class EventBigCard extends StatelessWidget {
  EventEntity? event;

  EventBigCard({
    super.key,
    this.event
  });

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
    return GestureDetector(
      onTap: () => _navigateToCardDetailPage(context),
      child: _buildCard(context)
    );
  }

  Widget _buildCard(BuildContext context) {
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
                              print("tabkub");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.favorite,
                                color: MyColors().primary,
                                size: 16,
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
