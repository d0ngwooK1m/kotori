import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/util/result.dart';

class IsOkayToMakeOrUseItemUseCase {
  final DiaryRepository repository;

  IsOkayToMakeOrUseItemUseCase(this.repository);

  Future<Result<bool?>> call() async {
    return await repository.isOkayToMakeOrUseItem();
  }
}