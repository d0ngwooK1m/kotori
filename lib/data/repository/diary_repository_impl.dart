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
  Future<Result<bool?>> isOkayToMakeOrUseItem() async {
    final result = await _dao.isOkayToMakeOrUseItem();
    try {
      return Result.success(result);
    } catch (e) {
      return Result.error(Exception('Is okay to make item failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> saveDiary({required Diary diary}) async {
    try {
      await _dao.saveDiary(diary: diary.toDiaryEntity());
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception('Save daily_diary failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Diary>>> getWeekDiaries({required DateTime now, int week = 0}) async {
    try {
      final diaryEntities = await _dao.getWeekDiaries(now: now, week: week);
      final result = diaryEntities.map((entity) => entity.toDiary()).toList();
      return Result.success(result);
    } catch (e) {
      return Result.error(Exception('Get week daily_diary failed : ${e.toString()}'));
    }
  }
}
