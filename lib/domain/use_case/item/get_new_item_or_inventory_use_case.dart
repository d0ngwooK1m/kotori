import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/util/result.dart';

class GetNewItemOrInventoryUseCase {
  final ItemRepository repository;

  GetNewItemOrInventoryUseCase(this.repository);

  Future<Result<Item>> call() async {
    return await repository.getNewItemOrInventory();
  }
}