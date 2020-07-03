import 'package:intl/intl.dart';

// Helper function to convert date to formatted string

String getDate(DateTime date) {
  var now = DateTime.now();
  // today date
  var todayDate = DateTime(now.year, now.month, now.day);
  // yesterday date
  var yesterdayDate = todayDate.subtract(Duration(days: 1));
  // tomorrow date
  var tomorrowData = todayDate.add(Duration(days: 1));
  // date in year, month and day
  final formattedDate = DateTime(date.year, date.month, date.day);

  if (formattedDate == todayDate) {
    return DateFormat("'Today  at'  h:mm a").format(date).toString();
  } else if (formattedDate == tomorrowData) {
    return DateFormat("'Tomorrow  at'  h:mm a").format(date).toString();
  } else if (formattedDate == yesterdayDate) {
    return DateFormat("'Yesterday  at'  h:mm a").format(date).toString();
  } else {
    return DateFormat("dd.MMM  'at'  h:mm a").format(date).toString();
  }
}
