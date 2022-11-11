import 'package:flutter/material.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/use_case/daily_diary_use_cases.dart';
import 'package:kotori/presentation/adventure/adventure_state.dart';
import 'package:kotori/presentation/daily_diary/daily_diary_state.dart';
import 'package:kotori/util/time.dart';

class DailyDiaryViewModel extends ChangeNotifier {
  final DailyDiaryUseCases useCases;

  DailyDiaryState _state = DailyDiaryState();

  DailyDiaryState get state => _state;

  DailyDiaryViewModel(this.useCases);

  Future<void> getDiary({required DateTime now}) async {
    final result = await useCases.getDiaryUseCase();
    result.when(
      success: (data) {
        _state = state.copyWith(
          diary: data,
          message: null,
        );
      },
      error: (e) {
        _state = state.copyWith(
          message: e.toString(),
        );
      },
    );
    notifyListeners();
  }

  Future<void> saveDiary({required Diary diary}) async {
    final result = await useCases.saveDiaryUseCase(diary: diary);
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
