import 'package:kotori/data/source/item/items_entity.dart';
import 'package:kotori/data/source/item/new_item_entity.dart';
import 'package:kotori/data/source/item/to_delete_item_entity.dart';

abstract class ItemDao {
  Future<List<ItemsEntity>> getItemsWithInventories();

  Future<void> saveItemsWithInventories({required List<ItemsEntity> items});

  Future<NewItemEntity> getNewItemOrInventory();

  Future<void> saveNewItemOrInventory({required NewItemEntity item});

  Future<ToDeleteItemEntity> getToDeleteItemOrInventory();

  Future<void> saveToDeleteItemOrInventory({required ToDeleteItemEntity item});
}