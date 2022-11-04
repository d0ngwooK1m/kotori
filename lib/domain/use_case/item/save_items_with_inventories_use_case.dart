import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/util/result.dart';

class SaveItemsWithInventoriesUseCase {
  final ItemRepository repository;

  SaveItemsWithInventoriesUseCase(this.repository);

  Future<Result<void>> call({required List<Item> items}) async {
    return await repository.saveItemsWithInventories(items: items);
  }
}