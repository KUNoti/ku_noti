
import 'package:ar_location_viewer/ar_annotation.dart';

enum AnnotationType {
  ku, music, sport, art, workshop, food, unknown
}

// Utility function to map tags to annotation types
AnnotationType getAnnotationTypeFromTag(String? tag) {
  switch (tag?.toLowerCase()) {
    case 'ku':
      return AnnotationType.ku;
    case 'music':
      return AnnotationType.music;
    case 'sport':
      return AnnotationType.sport;
    case 'art':
      return AnnotationType.art;
    case 'workshop':
      return AnnotationType.workshop;
    case 'food':
      return AnnotationType.food;
    default:
      return AnnotationType.unknown;  // Handle unexpected tags
  }
}

class Annotation extends ArAnnotation {
  final AnnotationType type;
  final String title;

  Annotation({
    required super.uid,
    required super.position,
    required this.type,
    required this.title,
  });
}
