import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/util/result.dart';

class IsOkayToMakeNewItemUseCase {
  final DiaryRepository repository;

  IsOkayToMakeNewItemUseCase(this.repository);

  Future<Result<bool?>> call() async {
    return await repository.isOkayToMakeItem();
  }
}