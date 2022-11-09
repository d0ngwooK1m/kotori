import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/util/result.dart';

class SaveDiaryUseCase {
  final DiaryRepository repository;

  SaveDiaryUseCase(this.repository);

  Future<Result<void>> call({required Diary diary}) async {
    return await repository.saveDiary(diary: diary);
  }
}