import 'package:hive/hive.dart';
import 'package:kotori/data/source/item/item_dao.dart';
import 'package:kotori/data/source/item/item_entity.dart';

class ItemDaoImpl implements ItemDao {
  final Box<ItemEntity> itemsBox;
  final Box<ItemEntity> newItemBox;
  final Box<ItemEntity> toDeleteItemBox;

  ItemDaoImpl({
    required this.itemsBox,
    required this.newItemBox,
    required this.toDeleteItemBox,
  });

  @override
  Future<List<ItemEntity>> getItemsWithInventories() async {
    return itemsBox.values.toList();
  }

  @override
  Future<void> saveItemsWithInventories({required List<ItemEntity> items}) async {
    await itemsBox.clear();
    for (final item in items) {
      await itemsBox.add(item);
    }
  }

  @override
  Future<ItemEntity> getNewItemOrInventory() async {
    return newItemBox.values.first;
  }

  @override
  Future<void> saveNewItemOrInventory({required ItemEntity item}) async {
    await newItemBox.clear();
    await newItemBox.add(item);
  }

  @override
  Future<ItemEntity> getToDeleteItemOrInventory() async {
    return toDeleteItemBox.values.first;
  }

  @override
  Future<void> saveToDeleteItemOrInventory({required ItemEntity item}) async {
    await toDeleteItemBox.clear();
    await toDeleteItemBox.add(item);
  }
}
