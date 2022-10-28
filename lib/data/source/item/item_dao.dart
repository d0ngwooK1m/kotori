import 'package:kotori/data/source/item/item_entity.dart';

abstract class ItemDao {
  Future<List<ItemEntity>> getItemsWithInventories();

  Future<void> saveItemsWithInventories({required List<ItemEntity> items});

  Future<ItemEntity> getNewItemOrInventory();

  Future<void> saveNewItemOrInventory({required ItemEntity item});

  Future<ItemEntity> getToDeleteItemOrInventory();

  Future<void> saveToDeleteItemOrInventory({required ItemEntity item});
}