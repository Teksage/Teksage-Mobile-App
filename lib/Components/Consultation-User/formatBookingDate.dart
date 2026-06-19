import 'package:intl/intl.dart';

String formatBookingDate(String bookingDate) {
  final possibleFormats = [
    DateFormat("yyyy-MM-dd"),
    DateFormat("d MMMM, yyyy"),
  ];

  DateTime? parsedDate;

  for (var format in possibleFormats) {
    try {
      parsedDate = format.parseStrict(bookingDate.trim());
      break; // Success
    } catch (_) {
      continue; // Try next format
    }
  }

  if (parsedDate == null) {
    print("Error: Unsupported date format");
    return ""; // or throw, or return original string
  }

  return DateFormat("d MMMM, y").format(parsedDate); // Desired output format
}
