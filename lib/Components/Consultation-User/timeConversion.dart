import 'package:astro_prompt/config/Helper/display_timezone.dart';
import 'package:intl/intl.dart';

class TimeRange {
  final String startTime;
  final String endTime;

  TimeRange({required this.startTime, required this.endTime});
}

String convertDateToFormattedString(String dateString) {
  DateFormat inputFormat = DateFormat('d MMMM, yyyy');
  DateFormat outputFormat = DateFormat('yyyy-MM-dd');
  DateTime date = inputFormat.parse(dateString);
  return outputFormat.format(date);
}

TimeRange convertDateAndTimeRangeToISO(String dateString, String timeRange) {
  String formattedDate = convertDateToFormattedString(dateString);

  List<String> parts = timeRange.split(' - ');
  if (parts.length != 2) {
    throw FormatException('Invalid time range format');
  }

  DateFormat timeInputFormat = DateFormat('h:mm a');
  DateFormat timeOutputFormat = DateFormat('HH:mm:ss');

  DateTime startTime = timeInputFormat.parse(parts[0].trim());
  DateTime endTime = timeInputFormat.parse(parts[1].trim());

  String startDateTime = '${formattedDate}T${timeOutputFormat.format(startTime)}';
  String endDateTime = '${formattedDate}T${timeOutputFormat.format(endTime)}';

  return TimeRange(startTime: startDateTime, endTime: endDateTime);
}

String convertDateToReadableFormat(String isoDateTime) {
  DateTime dateTime = DateTime.parse(isoDateTime);
  DateFormat outputFormat = DateFormat('d MMM, yyyy');
  return outputFormat.format(dateTime);
}

String convertTimeRangeToReadable(String startTime, String endTime, {String? zone}) {
  print('Start Time: $startTime, End Time: $endTime');
  DateTime start = displayDateTimeFromIso(startTime, zone: zone);
  DateTime end = displayDateTimeFromIso(endTime, zone: zone);

  DateFormat timeFormat = DateFormat('h:mm a');
  return '${timeFormat.format(start)} - ${timeFormat.format(end)}';
}

DateTime parseWithoutOffset(String dateTimeString) {
  return parseWallClockIso(dateTimeString);
}
