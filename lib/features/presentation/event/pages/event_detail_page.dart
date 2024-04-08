import 'package:flutter/material.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/core/constants/constants.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';

class EventDetailPage extends StatelessWidget {
  final EventEntity? event;
  const EventDetailPage({
    super.key,
    this.event
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // bottomNavigationBar: _buildBottomButton(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  // Event image
                  Image.network(
                    event?.image ?? kDefaultImage,
                    width: double.infinity,
                    height: 500,
                    fit: BoxFit.cover,
                  ),
                  // Back button and like button
                  Positioned(
                    top: 40, // Adjust padding according to your app bar height
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors
                                .black),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.favorite_border, color: Colors
                                .black),
                            onPressed: () {
                              // Like event action
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event title
                    Text(
                      event?.title ?? 'Event title',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Event tags
                    const Divider(),
                    // Event date and time
                    _buildDateDetail(context),
                    _buildLocationDetail(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateDetail(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.date_range,
            color: MyColors().primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Monday, December 24, 2022',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text(
                '18.00 - 23.00 PM',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),

              TextButton(
                onPressed: () {
                  // TODO: Implement the navigation to maps
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: MyColors().primary,
                  shape: const StadiumBorder(),
                ),
                child: const Text('Add to My Calendar'),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildLocationDetail(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.location_on,
            color: MyColors().primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Grand Park, New York City, US',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text(
                'Grand City St. 100, New York, United States.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),

              TextButton(
                onPressed: () {
                  // _launchMapsUrl(event!.latitude!, event!.longitude!);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: MyColors().primary,
                  shape: const StadiumBorder(),
                ),
                child: const Text('See Location on Maps'),
              ),
            ],
          ),
        ),

      ],
    );
  }

  // Widget _buildBottomButton(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  //     child: Row(
  //       children: [
  //         CustomButton(
  //           buttonText: 'Register',
  //           onPressed: () {},
  //           backColor: Colors.deepPurpleAccent[50],
  //           foreColor: MyColors().primary,
  //         ),
  //         const Spacer(),
  //         CustomButton(
  //             buttonText: 'Navigate',
  //             onPressed: () {},
  //           backColor: Colors.deepPurpleAccent,
  //           foreColor: Colors.white,
  //         )
  //       ],
  //     ),
  //   );
  // }
}