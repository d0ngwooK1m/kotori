import 'package:flutter/material.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/presentation/diary/diary_state.dart';

class DiaryViewModel extends ChangeNotifier {
  final DiaryRepository repository;

  var _state = DiaryState();

  DiaryState get state => _state;

  DiaryViewModel(this.repository);

  Future<void> getTodayDiary() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.getDiary();
    result.when(
      success: (diary) {
        _state = state.copyWith(
          diary: diary,
          message: null,
          isLoading: false,
        );
      },
      error: (e) {
        _state = state.copyWith(
          diary: null,
          message: e.toString(),
          isLoading: false,
        );
      },
    );
    notifyListeners();
  }

  Future<void> insertTodayDiary(Diary diary) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.insertDiary(diary);
    result.when(
      success: (success) {
        _state = state.copyWith(diary: diary, isLoading: false, message: success);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  Future<void> editTodayDiary(Diary diary) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.editDiary(diary);
    result.when(
      success: (success) {
        _state = state.copyWith(diary: diary, isLoading: false, message: success);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }
}
