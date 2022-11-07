import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/util/result.dart';

class GetDiaryUseCase {
  final DiaryRepository repository;

  GetDiaryUseCase(this.repository);

  Future<Result<Diary>> call({required DateTime now}) async {
    return await repository.getDiary(now: now);
  }
}