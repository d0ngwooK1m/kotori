import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/util/result.dart';

class GetWeekDiariesUseCase {
  final DiaryRepository repository;

  GetWeekDiariesUseCase(this.repository);

  Future<Result<Map<int, Diary>>> call({required DateTime now, int week = 0}) async {
    return await repository.getWeekDiaries(now: now, week: week);
  }
}