import 'package:flutter/material.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/use_case/diary/daily_diary/daily_diary_use_cases.dart';
import 'package:kotori/presentation/daily_diary/daily_diary_state.dart';
import 'package:kotori/util/time.dart';

class DailyDiaryViewModel extends ChangeNotifier {
  final DailyDiaryUseCases useCases;

  var _state = DailyDiaryState(now: Time.now);

  DailyDiaryState get state => _state;

  DailyDiaryViewModel(this.useCases);

  Future<void> getDiary({required DateTime now}) async {
    _state = state.copyWith(
        diary: Diary(emotion: 0, desc: '', picture: '', date: Time.now));

    final result = await useCases.getDiaryUseCase(now: now);
    result.when(
      success: (data) {
        _state = state.copyWith(
          diary: data,
          message: null,
        );
      },
      error: (e) {
        _state = state.copyWith(
          diary: null,
          message: e.toString(),
        );
      },
    );
    notifyListeners();
  }

  Future<void> saveDiary({required DateTime now, required Diary editedDiary}) async {
    if (state.now == editedDiary.date) {
      final result =
      await useCases.saveDiaryUseCase(now: now, editedDiary: editedDiary);
      result.when(
        success: (none) {
          _state = state.copyWith(message: null);
        },
        error: (e) {
          _state = state.copyWith(message: e.toString());
        },
      );
    }
  }
}
