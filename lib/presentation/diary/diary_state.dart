import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kotori/domain/model/diary.dart';

part 'diary_state.freezed.dart';

part 'diary_state.g.dart';

@freezed
class DiaryState with _$DiaryState {
  factory DiaryState({
    Diary? diary,
    String? message,
    @Default(false) bool isLoading,
  }) = _DiaryState;

  factory DiaryState.fromJson(Map<String, dynamic> json) => _$DiaryStateFromJson(json);
}