import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/util/result.dart';

class GetToDeleteItemOrInventoryUseCase {
  final ItemRepository repository;

  GetToDeleteItemOrInventoryUseCase(this.repository);

  Future<Result<Item>> call() async {
    return await repository.getToDeleteItemOrInventory();
  }
}