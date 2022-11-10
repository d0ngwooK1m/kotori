import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';

class GetDiaryUseCase {
  final DiaryRepository repository;

  GetDiaryUseCase(this.repository);

  Future<Result<Diary>> call() async {
    return await repository.getDiary(now: Time.now);
  }
}