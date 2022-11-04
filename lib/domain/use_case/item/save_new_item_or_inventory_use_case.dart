import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/util/result.dart';

class SaveNewItemOrInventoryUseCase {
  final ItemRepository repository;

  SaveNewItemOrInventoryUseCase(this.repository);

  Future<Result<void>> call({required Item item}) async {
    return await repository.saveNewItemOrInventory(item: item);
  }
}