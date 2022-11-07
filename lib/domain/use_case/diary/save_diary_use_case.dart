import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/util/result.dart';

class SaveDiaryUseCase {
  final DiaryRepository repository;

  SaveDiaryUseCase(this.repository);

  Future<Result<void>> call({required DateTime now, required Diary editedDiary}) async {
    return await repository.saveDiary(now: now, editedDiary: editedDiary);
  }
}