import 'package:kotori/data/mapper/diary_mapper.dart';
import 'package:kotori/data/source/emotion_dao.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/emotion_repository.dart';
import 'package:kotori/util/result.dart';

class EmotionRepositoryImpl implements EmotionRepository {
  final EmotionDao _dao;

  EmotionRepositoryImpl(this._dao);

  @override
  Future<Result<String>> editDiary(Diary diary) async {
    try {
      await _dao.editDiary(diary.toDiaryEntity());
      return const Result.success('Edit diary successfully!');
    } catch (e) {
      return Result.error(Exception('Edit diary failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<Diary>> getDiary() async {
    try {
      final diaryEntity = await _dao.getDiary();
      return Result.success(diaryEntity.toDiary());
    } catch (e) {
      return Result.error(Exception('Get diary failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<String>> insertDiary(Diary diary) async {
    try {
      await _dao.insertDiary(diary.toDiaryEntity());
      return const Result.success('Insert diary successfully');
    } catch (e) {
      return Result.error(Exception('Insert diary failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<Map<int, Diary>>> getWeekDiaries({int week = 0}) async {
    try {
      final map = await _dao.getWeekDiaries(week: week);
      final Map<int, Diary> result = {};
      map.forEach((key, diaryEntity) {
        result.putIfAbsent(key, () => diaryEntity.toDiary());
      });
      return Result.success(result);
    } catch (e) {
      return Result.error(Exception('Get week diary failed : ${e.toString()}'));
    }
  }
}
