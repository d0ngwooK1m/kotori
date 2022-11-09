import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary.freezed.dart';

part 'diary.g.dart';

@freezed
class Diary with _$Diary {
  factory Diary({
    required int emotion,
    required String picture,
    required String desc,
    required DateTime date,
    @Default(false) bool isSaved,
  }) = _Diary;

  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);
}