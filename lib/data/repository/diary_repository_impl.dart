import 'package:kotori/data/mapper/diary_mapper.dart';
import 'package:kotori/data/source/diary/diary_dao.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/util/result.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final DiaryDao _dao;

  DiaryRepositoryImpl(this._dao);

  @override
  Future<Result<Diary>> getDiary({required DateTime now}) async {
    try {
      final diaryEntity = await _dao.getDiary(now: now);
      return Result.success(diaryEntity.toDiary());
    } catch (e) {
      return Result.error(Exception('Get daily_diary failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> saveDiary({required DateTime now, required Diary editedDiary}) async {
    try {
      await _dao.saveDiary(now: now, editedDiary: editedDiary.toDiaryEntity());
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception('Save daily_diary failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<Map<int, Diary>>> getWeekDiaries({required DateTime now, int week = 0}) async {
    try {
      final map = await _dao.getWeekDiaries(now: now, week: week);
      final Map<int, Diary> result = {};
      map.forEach((key, diaryEntity) {
        result.putIfAbsent(key, () => diaryEntity.toDiary());
      });
      return Result.success(result);
    } catch (e) {
      return Result.error(Exception('Get week daily_diary failed : ${e.toString()}'));
    }
  }
}
