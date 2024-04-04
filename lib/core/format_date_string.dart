import 'package:intl/intl.dart';

// String formatDateString(String dateString) {
//   // Parse the date string into a DateTime object
//   DateTime dateTime = DateTime.parse(dateString).toLocal();
//
//   // Define the date format
//   DateFormat dateFormat = DateFormat('EEE, MMM d - HH:mm');
//
//   // Format the start time
//   String formattedStartTime = dateFormat.format(dateTime);
//
//   // Assume the end time is 4 hours later (since the end time is not provided)
//   String formattedEndTime = DateFormat('HH:mm').format(dateTime.add(Duration(hours: 4))) + ' PM';
//
//   // Combine the start and end times
//   return '$formattedStartTime - $formattedEndTime';
// }
//
// String formattedDate = formatDateString("2024-03-30T19:40:00Z");

String formatDate(DateTime? dateTime) {
  DateFormat dateFormat = DateFormat('EEE, MMM d - HH:mm');
  String formattedStartTime = dateFormat.format(dateTime!);
  return formattedStartTime;
}
