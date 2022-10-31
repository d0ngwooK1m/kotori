import 'package:hive/hive.dart';
import 'package:kotori/data/source/item/item_dao.dart';
import 'package:kotori/data/source/item/items_entity.dart';
import 'package:kotori/data/source/item/new_item_entity.dart';
import 'package:kotori/data/source/item/to_delete_item_entity.dart';

class ItemDaoImpl implements ItemDao {
  final Box<ItemsEntity> itemsBox;
  final Box<NewItemEntity> newItemBox;
  final Box<ToDeleteItemEntity> toDeleteItemBox;

  ItemDaoImpl({
    required this.itemsBox,
    required this.newItemBox,
    required this.toDeleteItemBox,
  });

  @override
  Future<List<ItemsEntity>> getItemsWithInventories() async {
    return itemsBox.values.toList();
  }

  @override
  Future<void> saveItemsWithInventories({required List<ItemsEntity> items}) async {
    await itemsBox.clear();
    for (final item in items) {
      await itemsBox.add(item);
    }
  }

  @override
  Future<NewItemEntity> getNewItemOrInventory() async {
    return newItemBox.values.first;
  }

  @override
  Future<void> saveNewItemOrInventory({required NewItemEntity item}) async {
    await newItemBox.clear();
    await newItemBox.add(item);
  }

  @override
  Future<ToDeleteItemEntity> getToDeleteItemOrInventory() async {
    return toDeleteItemBox.values.first;
  }

  @override
  Future<void> saveToDeleteItemOrInventory({required ToDeleteItemEntity item}) async {
    await toDeleteItemBox.clear();
    await toDeleteItemBox.add(item);
  }
}
