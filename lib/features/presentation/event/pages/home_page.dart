import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/core/constants/constants.dart';
import 'package:ku_noti/features/presentation/event/pages/search_page.dart';
import 'package:ku_noti/features/presentation/event/widgets/select_chips.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> chipLabels = ['All', 'Music', 'Art', 'Workshop'];
  int selectedChipIndex = 0;

  void navigationToSearchPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SearchPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSearchBarButton(context),
              _buildFeaturedSection(context),
               const SizedBox(height: 16),
              _buildPopularSectionGridWrapper(context)
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String name = 'Guest';
          String imagePath = kDefaultImage;

          if (state is AuthDone && state.user != null) {
            name = state.user!.name!;
            imagePath = state.user!.imagePath!;
          }

          // Build the AppBar with user info
          return AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 10,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imagePath),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Good Morning 👋',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                  // Action for the button press
                },
              ),
              const SizedBox(width: 16),
            ],
          );
        },
      ),
    );
  }


  Widget _buildFeaturedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  navigationToSearchPage(context);
                },
                child: Text('See All',style: TextStyle(color: MyColors().primary),),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 350,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
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
                              const Text(
                                'National Music Festival',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Mon, Dec 24 - 18:00 - 23:00 PM', // Replace with your event time
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
                                  const Text(
                                    'Grand Park, New York', // Replace with your event location
                                    style: TextStyle(color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(width: 4),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Popular Event 🔥', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

              GestureDetector(
                onTap: () {
                  navigationToSearchPage(context);
                },
                child: Text('See All', style: TextStyle(color: MyColors().primary))
              ),
            ],
          ),
        ),

        SelectChips(
            selectedChipIndex: selectedChipIndex,
            onChipSelected: (String selectedLabel, int index) {
              print(selectedLabel);
              setState(() {
                selectedChipIndex = index;
              });
            }
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6, // for example, 60% of the screen height
          child: _buildPopularSection(),
        ),
      ],
    );
  }

  Widget _buildPopularSection() {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Event Title', // Replace with your event title
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fri, Dec 20 - 13:00 - 15:00', // Replace with your event date and time
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
                        const Expanded(
                          child: Text(
                            'New Avenue, Washington', // Replace with your event location
                            style: TextStyle(fontSize: 12),
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
      },
    );
  }

  Widget _buildSearchBarButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigationToSearchPage(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: const EdgeInsets.all(16.0),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'What event are you looking for...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
            ),
            Icon(Icons.tune, color: MyColors().primary),
          ],
        ),
      ),
    );
  }

}
