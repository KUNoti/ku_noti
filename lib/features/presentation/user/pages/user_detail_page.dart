import 'package:flutter/material.dart';
import 'package:ku_noti/core/constants/constants.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomButton(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Event image
                Image.network(
                  kDefaultImage,
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
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event title
                  Text(
                    'National Music Festival',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Event tags
                  Divider(),
                  // Event date and time
                  _buildLocationDetail(context),
                  _buildLocationDetail(context),
                  _buildLocationDetail(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDetail(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // Align items to the start of the row
      children: [
        // Location icon container
        Container(
          padding: EdgeInsets.all(10), // White space around the icon
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.2), // Transparent purple
            shape: BoxShape.circle, // Circular shape
          ),
          child: Icon(
            Icons.location_on, // Location icon
            color: Colors.purple, // Purple color to match the design
            size: 24, // Icon size
          ),
        ),
        SizedBox(width: 8), // Space between icon and text
        // Column for text and detail
        Expanded( // Allows column to take remaining space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Align text to the start
            children: [
              Text(
                'Grand Park, New York City, US',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Grand City St. 100, New York, United States.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 8), // Space before the button
              // Button for maps
              TextButton(
                onPressed: () {
                  // TODO: Implement the navigation to maps
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple, // Text color
                  shape: StadiumBorder(), // Rounded edges
                ),
                child: Text('See Location on Maps'),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement book event functionality
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.purple,
          minimumSize: const Size(double.infinity, 50), // width and height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text('Book Event'),
      ),
    );
  }
}