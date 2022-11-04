import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/util/result.dart';

class SaveToDeleteItemOrInventoryUseCase {
  final ItemRepository repository;

  SaveToDeleteItemOrInventoryUseCase(this.repository);

  Future<Result<void>> call({required Item item}) async {
    return repository.saveToDeleteItemOrInventory(item: item);
  }
}