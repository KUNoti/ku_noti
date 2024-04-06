
import 'package:flutter/material.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/features/presentation/event/widgets/create_event_dialog.dart';

class MyEventPage extends StatelessWidget {
  const MyEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(context),
        )
    );
  }

  // void _handleCreateEvent(BuildContext context) {
  //
  // }

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

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [

      ],
    );
  }

  Widget _buildFollowTagSection(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
