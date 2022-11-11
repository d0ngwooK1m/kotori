import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/util/result.dart';

abstract class DiaryRepository {
  Future<Result<Diary>> getDiary({required DateTime now});

  Future<Result<bool?>> isOkayToMakeItem();

  Future<Result<void>> saveDiary({required Diary diary});

  Future<Result<Map<int, Diary>>> getWeekDiaries({required DateTime now, int week = 0});
}