import 'package:flutter/foundation.dart';
import 'package:kotori/domain/use_case/diary/get_week_diaries_use_case.dart';
import 'package:kotori/presentation/week_diaries/week_diaries_state.dart';

class WeekDiariesViewModel extends ChangeNotifier {
  final GetWeekDiariesUseCase useCase;

  WeekDiariesState _state = WeekDiariesState();

  WeekDiariesState get state => _state;

  WeekDiariesViewModel(this.useCase);

  Future<void> getWeekDiaries({int week = 0}) async {
    final result = await useCase(week: week);
    final defaultWeekDiaries = {
      0: null,
      1: null,
      2: null,
      3: null,
      4: null,
      5: null,
      6: null,
    };
    result.when(
      success: (data) {
        // print(data.length);
        _state = state.copyWith(weekDiaries: data, week: week, message: null);
      },
      error: (e) {
        _state = state.copyWith(weekDiaries: defaultWeekDiaries, message: e.toString());
      },
    );
    notifyListeners();
  }
}
