import 'package:kotori/domain/model/item.dart';
import 'package:kotori/util/result.dart';

abstract class ItemRepository {
  Future<Result<Item>> getNewItem();

  Future<Result<List<Item>>> getAllItems();

  Future<Result<List<Item>>> updateAllItems(List<Item> items);

  Future<Result<String>> deleteItem(Item item);
}