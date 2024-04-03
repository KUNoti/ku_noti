import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/features/presentation/event/widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> chipLabels = ['All', 'Music', 'Art', 'Workshop'];
  // State to keep track of the selected chip
  int selectedChipIndex = 0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MySearchBarWidget(),
            _buildFeaturedSection(),
            _buildPopularSectionGridWrapper(context)
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent, // Assuming a transparent AppBar
      elevation: 0, // No shadow
      titleSpacing: 10, // Remove the default horizontal title padding
      title: Row(
        children: [
          CircleAvatar(
            radius: 30, // Adjust the radius for a larger image
            backgroundImage: NetworkImage('https://www.shutterstock.com/image-vector/default-ui-image-placeholder-wireframes-600nw-1037719192.jpg'),
          ),
          SizedBox(width: 16), // Spacing between the avatar and the text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Align text to the center vertically
            children: [
              Text(
                'Good Morning 👋', // Smaller text above the name
                style: TextStyle(
                  color: Colors.black, // Assuming a dark text color
                  fontSize: 16, // Smaller font size for the greeting
                ),
              ),
              Text(
                'Andrew Ainsley', // Name in a larger text
                style: TextStyle(
                  color: Colors.black, // Assuming a dark text color
                  fontSize: 24, // Larger font size for the name
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications, // Replace with your icon as per your design
                color: Colors.black, // Assuming a dark icon color
              ),
              onPressed: () {
                // Action for the button press
              },
            ),
            SizedBox(width: 16)
          ]
        ),
      ],
    );
  }

  Widget _buildFeaturedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Handle 'See All' tap
                },
                child: Text('See All',style: TextStyle(color: MyColors().primary),),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 350, // Adjust height to fit content
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10, // Replace with your actual number of items
            itemBuilder: (context, index) {
              return Container(
                width: 300, // Adjust width to fit content
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24), // Rounded corners
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        'https://www.shutterstock.com/image-vector/default-ui-image-placeholder-wireframes-600nw-1037719192.jpg', // Replace with your image URLs
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
                                'National Music Festival', // Replace with your event title
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Mon, Dec 24 - 18:00 - 23:00 PM', // Replace with your event time
                                style:  TextStyle(color: MyColors().primary,fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: MyColors().primary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Grand Park, New York', // Replace with your event location
                                    style: TextStyle(color: Colors.black, fontSize: 14),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.favorite,
                                    color: MyColors().primary,
                                    size: 16,
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
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularSectionGridWrapper(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Popular Event 🔥', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  // Handle 'See All' tap
                },
                child: Text('See All', style: TextStyle(color: MyColors().primary),),
              ),
            ],
          ),
        ),
        _buildSelectChips(),
        Container(
          height: MediaQuery.of(context).size.height * 0.6, // for example, 60% of the screen height
          child: _buildPopularSection(),
        ),
      ],
    );
  }

  Widget _buildPopularSection() {
    return GridView.builder(
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8, // Adjust the aspect ratio based on your image sizes and text content
      ),
      itemCount: 10, // Replace with your actual number of items
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  'https://www.shutterstock.com/image-vector/default-ui-image-placeholder-wireframes-600nw-1037719192.jpg', // Replace with your event image URL
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Title', // Replace with your event title
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Fri, Dec 20 - 13:00 - 15:00', // Replace with your event date and time
                      style: TextStyle(fontSize: 12, color: MyColors().primary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: MyColors().primary,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'New Avenue, Washington', // Replace with your event location
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                        SizedBox(width: 4),
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
      },
    );
  }

  Widget _buildSelectChips() {
    // Dummy data for the chips, replace with your actual data
    // Default to the first chip being selected

    return Container(
      height: 50, // Adjust the height to fit your design
      margin: EdgeInsets.symmetric(vertical: 10), // Vertical spacing for aesthetic
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chipLabels.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              label: Text(
                chipLabels[index],
                style: TextStyle(
                  color: selectedChipIndex == index ? Colors.white : Colors.black,
                ),
              ),
              backgroundColor: selectedChipIndex == index ? MyColors().primary : Colors.grey.shade200,
              selectedColor: MyColors().primary, // The color when the chip is selected
              selected: selectedChipIndex == index,
              onSelected: (bool selected) {
                // Set state or update the UI accordingly when a chip is selected
                // You will need to use a StatefulWidget or another state management solution
                setState(() {
                  if (selected) {
                    selectedChipIndex = index;
                  }
                });
              },
              shape: StadiumBorder(
                side: BorderSide(
                  color: selectedChipIndex == index ? MyColors().primary : Colors.transparent,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Inner padding for the chip
            ),
          );
        },
      ),
    );
  }
}
