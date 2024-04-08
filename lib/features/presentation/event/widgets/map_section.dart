
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_state.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/events_bloc.dart';
import 'package:ku_noti/features/presentation/event/widgets/event_horizontal_card.dart';

class MapSection extends StatefulWidget {
  const MapSection({super.key});

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(13.854529, 100.570012);
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
  }

  Future<void> _createMarkers(List<EventEntity> events) async {
    Set<Marker> newMarkers = {};

    for (EventEntity event in events) {
      final marker = Marker(
        markerId: MarkerId(event.id.toString()),
        position: LatLng(event.latitude!.toDouble(), event.longitude!.toDouble()),
        infoWindow: InfoWindow(
          title: event.title,
          snippet: event.detail,
          onTap: () {
            _showEventCard(event);
          },
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
      newMarkers.add(marker);
    }

    setState(() {
      _markers = newMarkers;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fetchEventsAndCreateMarkers();
  }

  void _fetchEventsAndCreateMarkers() {
    final eventsBloc = context.read<EventsBloc>();
    final state = eventsBloc.state;
    if (state is EventSuccess) {
      _createMarkers(state.events!);
    }
  }

  void _showEventCard(EventEntity event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,  // Ensuring the modal background is transparent
      builder: (BuildContext context) {
        // Wrap the card with Container to control the white background and round corners
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Wrap(
            children: [EventHorizCard(event: event)],  // Wrap ensures the card sizes to its content
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is EventSuccess) {
            _createMarkers(state.events!);
          }
          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
            markers: _markers,
            gestureRecognizers: Set()
              ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
          );
        },
      ),
    );
  }
}
