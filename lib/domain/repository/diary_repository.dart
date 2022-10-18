import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/util/result.dart';

abstract class DiaryRepository {
  Future<Result<Diary>> getDiary();

  Future<Result<String>> insertDiary(Diary diary);

  Future<Result<String>> editDiary(Diary diary);

  Future<Result<Map<int, Diary>>> getWeekDiaries({int week = 0});
}