import 'package:kotori/data/source/item/item_entity.dart';

abstract class ItemDao {
  Future<ItemEntity> getNewItem();

  Future<List<ItemEntity>> getAllItems();

  Future<List<ItemEntity>> updateAllItems({required List<ItemEntity> items});

  Future<void> deleteItem({required ItemEntity item});
}