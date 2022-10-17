import 'package:hive_flutter/hive_flutter.dart';
import 'package:kotori/data/source/diary_entity.dart';

abstract class EmotionDao {
  final Box<DiaryEntity> box;

  EmotionDao({required this.box});

  Future<DiaryEntity> getDiary();

  Future<void> insertDiary(DiaryEntity diary);

  Future<void> editDiary(DiaryEntity editedDiary);

  Future<Map<int, DiaryEntity>> getWeekDiaries({int week = 0});
}