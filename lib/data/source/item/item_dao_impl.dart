import 'package:hive/hive.dart';
import 'package:kotori/data/source/item/item_dao.dart';
import 'package:kotori/data/source/item/item_entity.dart';
import 'package:kotori/util/time.dart';

class ItemDaoImpl implements ItemDao {
  final Box<ItemEntity> box;
  final now = Time.now;

  ItemDaoImpl(this.box);

  @override
  Future<void> deleteItem({required ItemEntity item}) async {
    for (var value in box.values) {
      if (item.date == value.date) {
        await box.delete(value.key);
        return;
      }
    }
  }

  @override
  Future<List<ItemEntity>> getAllItems() async {
    return box.values.toList();
  }

  @override
  Future<ItemEntity> getNewItem() async {
    return ItemEntity(
      name: '',
      desc: '',
      picture: '',
      date: now,
    );
  }

  @override
  Future<List<ItemEntity>> updateAllItems({required List<ItemEntity> items}) async {
    await box.clear();
    for (var item in items) {
      await box.add(item);
    }
    return getAllItems();
  }
}
