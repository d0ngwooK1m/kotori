import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/util/time.dart';

part 'daily_diary_state.freezed.dart';

@freezed
class DailyDiaryState with _$DailyDiaryState {
  factory DailyDiaryState({
    Diary? diary,
    String? message,
    required DateTime now,
  }) = _DailyDiaryState;
}
