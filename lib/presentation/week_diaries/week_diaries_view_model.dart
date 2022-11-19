import 'package:flutter/foundation.dart';
import 'package:kotori/domain/use_case/diary/get_week_diaries_use_case.dart';
import 'package:kotori/presentation/week_diaries/week_diaries_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeekDiariesViewModel extends ChangeNotifier {
  final GetWeekDiariesUseCase useCase;

  WeekDiariesState _state = WeekDiariesState();

  WeekDiariesState get state => _state;

  WeekDiariesViewModel(this.useCase);

  Future<void> getFirstDateEpoch() async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getInt('first_date_epoch');
    _state = state.copyWith(firstDownloadedDateEpoch: result ?? 0);
  }

  Future<void> getWeekDiaries({int week = 0}) async {
    final defaultWeekDiaries = List.generate(7, (index) => null);
    final result = await useCase(week: week);
    result.when(
      success: (data) {
        _state = state.copyWith(weekDiaries: data, week: week, message: null);
      },
      error: (e) {
        _state = state.copyWith(weekDiaries: defaultWeekDiaries, message: e.toString());
      },
    );
    notifyListeners();
  }
}
