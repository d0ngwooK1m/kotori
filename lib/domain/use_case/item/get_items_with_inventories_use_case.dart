import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/util/result.dart';

class GetItemsWithInventoriesUseCase {
  final ItemRepository repository;

  GetItemsWithInventoriesUseCase(this.repository);

  Future<Result<List<Item>>> call() async {
    return await repository.getItemsWithInventories();
  }
}