import 'package:intl/intl.dart';

class Time {
  static final now = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  static DateTime getWeekend(DateTime now, int week) {
    var weekend = now;
    for (var i = 0; i < 7; i++) {
      final candidate = now.add(Duration(days: i));
      if (candidate.weekday == DateTime.sunday) {
        weekend = candidate.subtract(Duration(days: 7 * week));
      }
    }
    return weekend;
  }
}