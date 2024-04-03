import 'package:flutter/material.dart';
import 'package:ku_noti/core/constants/colors.dart';

class EventHorizCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String location;
  final bool isFree;
  final VoidCallback onLiked;
  const EventHorizCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.location,
    this.isFree = false,
    required this.onLiked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 120,
                width: 120,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'National Music Festival', // Replace with your event title
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Mon, Dec 24 - 18:00 - 23:00 PM', // Replace with your event time
                style:  TextStyle(color: MyColors().primary,fontWeight: FontWeight.bold, fontSize: 12),
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
                    const Text(
                      'Grand Park, New York', // Replace with your event location
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    const SizedBox(width: 20),
                    Icon(
                      Icons.favorite_border,
                      color: MyColors().primary,
                      size: 16,
                    ),
                  ]
              ),
            ],
          ),
        ],
      ),
    );
  }


}




