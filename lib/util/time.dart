import 'package:intl/intl.dart';

class Time {
  static final now = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  static String getDateKey({int pastDays = 0}) {
    return Time.now.subtract(Duration(days: pastDays)).millisecondsSinceEpoch.toString();
  }

  static List<DateTime> getWeek(DateTime now, int week) {
    final List<DateTime> result = [];
    var weekend = now;
    for (var i = 0; i < 7; i++) {
      final candidate = now.add(Duration(days: i));
      if (candidate.weekday == DateTime.sunday) {
        weekend = candidate.subtract(Duration(days: 7 * week));
      }
    }

    for (var i = 0; i < 7; i++) {
      result.add(weekend.subtract(Duration(days: i)));
    }

    result.sort((a, b) => a.compareTo(b));
    return result;
  }
}