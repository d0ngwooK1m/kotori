import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';

class GetWeekDiariesUseCase {
  final DiaryRepository repository;

  GetWeekDiariesUseCase(this.repository);

  Future<Result<Map<int, Diary>>> call({int week = 0}) async {
    return await repository.getWeekDiaries(now: Time.now, week: week);
  }
}