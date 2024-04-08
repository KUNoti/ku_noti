import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_state.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/events_bloc.dart';
import 'package:ku_noti/features/presentation/event/widgets/ar/annotations.dart';
import 'package:ar_location_viewer/ar_location_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'annotation_viewer.dart';

class ARSection extends StatefulWidget {
  const ARSection({super.key});

  @override
  State<ARSection> createState() => _ARSectionState();
}

class _ARSectionState extends State<ARSection> {
  List<Annotation> annotations = [];
  
  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state is EventSuccess) {
              annotations = state.events!.map((EventEntity event) => createAnnotationFromEvent(event)).toList();

              return ArLocationWidget(
                annotations: annotations,
                showDebugInfoSensor: false,
                annotationViewerBuilder: (context, annotation) {
                  return AnnotationViewer(
                    key: ValueKey(annotation.uid),
                    annotation: annotation as Annotation,
                  );
                },
                onLocationChange: (Position position) {
                  // Optionally handle location changes here
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Annotation createAnnotationFromEvent(EventEntity event) {
    return Annotation(
      uid: const Uuid().v1(),
      position: Position(
        longitude: event.longitude?.toDouble() ?? 0,
        latitude: event.latitude?.toDouble() ?? 0,
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      ),
      type: getAnnotationTypeFromTag(event.tag),
      title: event.title ?? "Unknown Event",
    );
  }
}
