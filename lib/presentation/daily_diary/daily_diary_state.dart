import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kotori/domain/model/diary.dart';

part 'daily_diary_state.freezed.dart';

@freezed
class DailyDiaryState with _$DailyDiaryState {
  factory DailyDiaryState({
    Diary? diary,
    String? message,
  }) = _DailyDiaryState;
}
