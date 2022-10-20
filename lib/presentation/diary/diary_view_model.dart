import 'package:flutter/material.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/presentation/diary/diary_state.dart';

class DiaryViewModel extends ChangeNotifier {
  final DiaryRepository repository;

  final _state = DiaryState();

  DiaryState get state => _state;

  DiaryViewModel(this.repository);

  void getTodayDiary() async {
    state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.getDiary();
    result.when(
      success: (diary) {
        state.copyWith(
          diary: diary,
          message: null,
          isLoading: false,
        );
      },
      error: (e) {
        state.copyWith(
          diary: null,
          message: e.toString(),
          isLoading: false,
        );
      },
    );
    notifyListeners();
  }

  void insertTodayDiary(Diary diary) async {
    state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.insertDiary(diary);
    result.when(
      success: (success) {
        state.copyWith(isLoading: false, message: success);
      },
      error: (e) {
        state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  void editTodayDiary(Diary diary) async {
    state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.editDiary(diary);
    result.when(
      success: (success) {
        state.copyWith(isLoading: false, message: success);
      },
      error: (e) {
        state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }
}
