import 'package:kotori/data/source/diary/diary_entity.dart';

abstract class DiaryDao {
  Future<DiaryEntity> getDiary({required DateTime now});

  Future<void> saveDiary({required DiaryEntity diary});

  Future<Map<int, DiaryEntity>> getWeekDiaries({required DateTime now, int week = 0});
}