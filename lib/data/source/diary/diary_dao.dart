import 'package:kotori/data/source/diary/diary_entity.dart';

abstract class DiaryDao {
  Future<DiaryEntity> getDiary({required DateTime now});

  Future<void> insertDiary({required DiaryEntity diary});

  Future<void> editDiary({required DateTime now, required DiaryEntity editedDiary});

  Future<Map<int, DiaryEntity>> getWeekDiaries({required DateTime now, int week = 0});
}