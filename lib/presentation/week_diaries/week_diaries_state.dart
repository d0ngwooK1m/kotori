import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kotori/domain/model/diary.dart';

part 'week_diaries_state.freezed.dart';

part 'week_diaries_state.g.dart';

@freezed
class WeekDiariesState with _$WeekDiariesState {
  factory WeekDiariesState({
    @Default({
      0: null,
      1: null,
      3: null,
      4: null,
      5: null,
      6: null,
    }) Map<int, Diary?> weekDiaries,
    @Default(0) int week,
    String? message,
  }) = _WeekDiariesState;

  factory WeekDiariesState.fromJson(Map<String, dynamic> json) => _$WeekDiariesStateFromJson(json);
}