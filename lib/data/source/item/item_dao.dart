import 'package:kotori/data/source/item/item_entity.dart';

abstract class ItemDao {
  Future<List<ItemEntity>> addItemToItems({List<ItemEntity>? items});

  Future<List<ItemEntity>> deleteItemFromItems({required ItemEntity item});

  Future<ItemEntity> addNewItem();

  Future<ItemEntity> deleteNewItem();

  Future<ItemEntity> addToDeleteItem({required ItemEntity item});

  Future<ItemEntity> deleteToDeleteItem();
}