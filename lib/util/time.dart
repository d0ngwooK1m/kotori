import 'package:intl/intl.dart';

class Time {
  static final now = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
}