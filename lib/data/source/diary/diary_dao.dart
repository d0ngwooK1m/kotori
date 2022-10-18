import 'package:kotori/data/source/diary/diary_entity.dart';

abstract class DiaryDao {
  Future<DiaryEntity> getDiary();

  Future<void> insertDiary(DiaryEntity diary);

  Future<void> editDiary(DiaryEntity editedDiary);

  Future<Map<int, DiaryEntity>> getWeekDiaries({int week = 0});
}