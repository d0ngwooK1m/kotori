import 'package:kotori/domain/model/item.dart';
import 'package:kotori/util/result.dart';

abstract class ItemRepository {
  Future<Result<List<Item>>> getItemsWithInventories();

  Future<Result<void>> saveItemsWithInventories({required List<Item> items});

  Future<Result<Item>> getNewItemOrInventory();

  Future<Result<void>> saveNewItemOrInventory({required Item item});

  Future<Result<Item>> getToDeleteItemOrInventory();

  Future<Result<void>> saveToDeleteItemOrInventory({required Item item});
}