import 'package:flutter/material.dart';
import 'annotations.dart';

class AnnotationViewer extends StatelessWidget {
  const AnnotationViewer({
    super.key,
    required this.annotation,
  });

  final Annotation annotation;

  static final List<IconData> chipIcons = [
    // Adjusted for 'all' category if needed or add this in the enum
    Icons.school,         // ku
    Icons.music_note,     // music
    Icons.sports_basketball, // sport
    Icons.brush,          // art
    Icons.build,          // workshop
    Icons.food_bank,     // food
    Icons.all_inclusive,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: typeFactory(annotation.type),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    annotation.title,  // Now displaying the event title
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${annotation.distanceFromUser.toInt()} m',  // Assuming this method exists to get distance
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget typeFactory(AnnotationType type) {
    int index = type.index; // Get the index of the type in the enum
    IconData iconData = chipIcons[index]; // Fetch the corresponding icon data

    return Icon(
      iconData,
      size: 40,
      color: Colors.teal, // Default color for all icons, change if needed
    );
  }
}
