import 'package:hive/hive.dart';
import 'package:kotori/data/source/item/item_dao.dart';
import 'package:kotori/data/source/item/item_entity.dart';
import 'package:kotori/util/time.dart';

class ItemDaoImpl implements ItemDao {
  final Box<ItemEntity> itemsBox;
  final Box<ItemEntity> newItemBox;
  final Box<ItemEntity> toDeleteItemBox;

  final inventory = ItemEntity(name: '', desc: '', picture: '', date: Time.now, isInventory: true,);
  final newItem = ItemEntity(name: '', desc: '', picture: '', date: Time.now);

  ItemDaoImpl({
    required this.itemsBox,
    required this.newItemBox,
    required this.toDeleteItemBox,
  });

  @override
  Future<List<ItemEntity>> addItemToItems(
      {List<ItemEntity>? items}) async {
    if (items != null) {
      await itemsBox.clear();
      for (var item in items) {
        await itemsBox.add(item);
      }
    }
    return itemsBox.values.toList();
  }

  @override
  Future<List<ItemEntity>> deleteItemFromItems({required ItemEntity item}) async {
    final List<ItemEntity> items = [];
    for (var value in itemsBox.values) {
      if (item.date == value.date) {
        items.add(inventory);
      } else {
        items.add(value);
      }
    }
    await itemsBox.clear();
    final result = await addItemToItems(items: items);
    return result;
  }

  @override
  Future<ItemEntity> addNewItem() async {
    await newItemBox.clear();
    await newItemBox.add(newItem);
    return newItemBox.values.first;
  }

  @override
  Future<ItemEntity> deleteNewItem() async {
    await newItemBox.clear();
    await newItemBox.add(inventory);
    return newItemBox.values.first;
  }

  @override
  Future<ItemEntity> addToDeleteItem({required ItemEntity item}) async {
    await toDeleteItemBox.clear();
    await toDeleteItemBox.add(item);
    return toDeleteItemBox.values.first;
  }

  @override
  Future<ItemEntity> deleteToDeleteItem() async {
    await toDeleteItemBox.clear();
    await toDeleteItemBox.add(inventory);
    return toDeleteItemBox.values.first;
  }
}
