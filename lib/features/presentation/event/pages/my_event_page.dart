
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/features/data/event/models/follow_tag_request.dart';
import 'package:ku_noti/features/data/notification/service/firebase_service.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_state.dart';
import 'package:ku_noti/features/presentation/event/widgets/create_event_dialog.dart';
import 'package:ku_noti/features/presentation/event/widgets/event_horizontal_card.dart';
import 'package:ku_noti/features/presentation/event/widgets/select_tag_follow.dart';
import 'package:ku_noti/injection_container.dart';

class MyEventPage extends StatefulWidget {
  const MyEventPage({super.key});

  @override
  State<MyEventPage> createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  final List<String> chipLabels = ['KU', 'Music', 'Art', 'Workshop'];
  final List<IconData> chipIcons = [Icons.school, Icons.music_note, Icons.brush, Icons.build];
  Set<int> selectedTagIndices = {};
  String? token;
  @override
  initState()  {
    super.initState();
    fetchInitialData();
    BlocProvider.of<UserEventBloc>(context).add(LoadTag(token));
  }


  Future<void> fetchInitialData() async {
    // Fetch the Firebase token
    token = await sl<FirebaseService>().getFirebaseToken();
    print('Firebase Token: $token');

    if (mounted) {
      setState(() {
        // Update the state of your Widget
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: BlocListener<UserEventBloc, UserEventsState>(
            listener: (context, state) {
              if (state is LoadTagSuccess) {
                setState(() {
                  selectedTagIndices = Set.from(state.tags.map((tag) => chipLabels.indexOf(tag)).where((index) => index != -1));
                });
              }
              else if (state is FollowTagSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is UserEventsError) {
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }
            },
            child: BlocBuilder<UserEventBloc, UserEventsState>(
              builder: (context, state) {
                return _buildBody(context, state);
              },
            ),
          ),
        )
    );
  }
  Future openDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) => const CreateEventDialog(),
  );

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Row(
            children: [
              Text(
                "My Event",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: (){
                openDialog(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: MyColors().primary
              ),
              child: const Text(
                "Create Event",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16,)
          ],
        )
    );
  }

  Widget _buildBody(BuildContext context, UserEventsState state) {
    return SingleChildScrollView( // Wrap with SingleChildScrollView to provide a scrollable area
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use min to shrink to fit content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFollowTagSection(context),
            const SizedBox(height: 20), // Add some space
            const Text("Create by me", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10), // Add some space
            _buildEventList(state) // This will now work without needing to be in an Expanded widget
          ],
        ),
      ),
    );
  }

  void _handleTagSelection(String tag, bool isSelected, int index) async {

    // print('Debug token $token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to fetch Firebase token")));
      return;
    }

    final userEventBloc = BlocProvider.of<UserEventBloc>(context);
    // print(isSelected);
    if (isSelected) {
      userEventBloc.add(FollowTagPressed(FollowTagRequest(tag: tag, token: token)));
      selectedTagIndices.add(index);
    } else {
      userEventBloc.add(UnFollowTagPressed(FollowTagRequest(tag: tag, token: token)));
      print("object");
      selectedTagIndices.remove(index);
    }
    setState(() {});  // Trigger UI update
  }


  Widget _buildFollowTagSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Follow Tag", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SelectTagFollow(
          chipLabels: chipLabels,
          chipIcons: chipIcons,
          selectedChipIndices: selectedTagIndices,
          onChipSelected: (String tag, bool isSelected, int index) {
            setState(() {
              print(isSelected);
              _handleTagSelection(tag, isSelected, index);
            });
          },
        ),
      ],
    );
  }

  Widget _buildEventList(UserEventsState state) {
    if (state is UserEventsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is UserEventsSuccess) {
      return ListView.builder(
        shrinkWrap: true, // Important to allow ListView to size itself according to its children
        // physics: NeverScrollableScrollPhysics(), // Disable scrolling within the ListView
        itemCount: state.events?.length ?? 0,
        itemBuilder: (context, index) {
          final event = state.events?[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: EventHorizCard(event: event),
          );
        },
      );
    } else if (state is UserEventsError) {
      return Center(child: Text(state.errorMessage ?? "Error loading events"));
    } else {
      return const Center(child: Text("No data available."));
    }
  }
}
