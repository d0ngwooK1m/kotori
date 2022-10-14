import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kotori/util/emotion.dart';

part 'diary.freezed.dart';

part 'diary.g.dart';

@freezed
class Diary with _$Diary {
  factory Diary({
    required int emotion,
    required String picture,
    required String desc,
    required DateTime date,
  }) = _Diary;

  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);
}