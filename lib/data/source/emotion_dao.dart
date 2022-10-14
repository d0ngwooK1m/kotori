import 'package:hive/hive.dart';
import 'package:kotori/data/source/diary_entity.dart';
import 'package:intl/intl.dart';

class EmotionDao {
  final now = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd');

  // 일기 읽어오기
  Future<DiaryEntity> getDiary() async {
    final box = await Hive.openBox<DiaryEntity>('diaries.db');

    return box.values
        .where((diary) =>
    formatter.format(diary.date) == formatter.format(now))
        .toList()
        .first;
  }

  // 일기 추가
  Future<void> insertDiary(DiaryEntity diary) async {
    final box = await Hive.openBox<DiaryEntity>('diaries.db');
    await box.add(diary);
  }

  // 일기 수정
  Future<void> editDiary(DiaryEntity editedDiary) async {
    final box = await Hive.openBox<DiaryEntity>('diaries.db');
    final diaries = box.values.map((diary) {
      if (formatter.format(diary.date) == formatter.format(now)) {
        return editedDiary;
      } else {
        return diary;
      }
    });
    box.clear();
    box.addAll(diaries);
  }
}