import 'package:kotori/domain/model/item.dart';
import 'package:kotori/util/result.dart';

abstract class ItemRepository {
  Future<Result<List<Item>>> addItemToItems({List<Item>? items});

  Future<Result<List<Item>>> deleteItemFromItems({required Item item});

  Future<Result<Item>> addNewItem();

  Future<Result<Item>> deleteNewItem();

  Future<Result<Item>> addToDeleteItem({required Item item});

  Future<Result<Item>> deleteToDeleteItem();
}