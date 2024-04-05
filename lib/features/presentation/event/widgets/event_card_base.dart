import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ku_noti/features/data/event/models/follow_event_request.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_bloc.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/follow_event/follow_event_state.dart';
import 'package:ku_noti/features/presentation/event/pages/event_detail_page.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';

abstract class EventCardBase extends StatelessWidget {
  final EventEntity? event;

  const EventCardBase({super.key, this.event});

  void navigateToCardDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailPage(event: event)),
    );
  }

  void handleTap(BuildContext context) {
    final userId = context.read<AuthBloc>().state.user?.userId;
    if (userId == null) return;

    final currentState = context.read<FollowEventBloc>().state;
    if (currentState is FollowEventSuccess) {
      final isCurrentlyFollowed = currentState.followedEventIds?.contains(event?.id.toString());
      final followRequest = FollowRequest(userId: userId, eventId: event?.id);

      if (isCurrentlyFollowed!) {
        context.read<FollowEventBloc>().add(UnFollowEventPressed(followRequest));
      } else {
        context.read<FollowEventBloc>().add(FollowEventPressed(followRequest));
      }
    }
  }

  // Abstract build method to be implemented by subclasses
  @override
  Widget build(BuildContext context);
}
