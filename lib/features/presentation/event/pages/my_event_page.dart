
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/user_event/user_event_state.dart';
import 'package:ku_noti/features/presentation/event/widgets/create_event_dialog.dart';
import 'package:ku_noti/features/presentation/event/widgets/event_horizontal_card.dart';
import 'package:ku_noti/features/presentation/event/widgets/select_tag_follow.dart';

class MyEventPage extends StatefulWidget {
  const MyEventPage({super.key});

  @override
  State<MyEventPage> createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  Set<int> selectedTagIndices = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: BlocBuilder<UserEventBloc, UserEventsState>(
            builder: (context, state) {
              return _buildBody(context, state);
            },
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

  Widget _buildFollowTagSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Follow Tag", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SelectTagFollow(
          selectedChipIndices: selectedTagIndices,
          onChipSelected: (String label, bool isSelected, int index) {
            setState(() {
              if (isSelected) {
                selectedTagIndices.add(index);
                // print("Selected: $label");
              } else {
                selectedTagIndices.remove(index);
                // print("Deselected: $label");
              }
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
            padding: const EdgeInsets.symmetric(vertical: 8), // Vertical padding for better spacing
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
