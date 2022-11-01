import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:kotori/data/mapper/item_mapper.dart';
import 'package:kotori/data/source/item/item_dao_impl.dart';
import 'package:kotori/data/source/item/items_entity.dart';
import 'package:kotori/data/source/item/new_item_entity.dart';
import 'package:kotori/data/source/item/to_delete_item_entity.dart';
import 'package:kotori/util/default_item.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  test('item_dao test', () async {
    final defaultItem = DefaultItem.item;
    final inventory = DefaultItem.inventory;
    final dir = await getApplicationDocumentsDirectory();
    Hive
      ..init(dir.path)
      ..registerAdapter(ItemsEntityAdapter())
      ..registerAdapter(NewItemEntityAdapter())
      ..registerAdapter(ToDeleteItemEntityAdapter());
    final newItemBox = await Hive.openBox<NewItemEntity>('test_new_item.db');
    final itemsBox = await Hive.openBox<ItemsEntity>('test_items.db');
    final toDeleteItemBox =
        await Hive.openBox<ToDeleteItemEntity>('test_to_delete_item.db');

    await newItemBox.clear();
    await itemsBox.clear();
    await toDeleteItemBox.clear();

    final dao = ItemDaoImpl(
        newItemBox: newItemBox,
        itemsBox: itemsBox,
        toDeleteItemBox: toDeleteItemBox);

    await dao.saveNewItemOrInventory(item: defaultItem.toNewItemEntity());
    final newItemResult = await dao.getNewItemOrInventory();
    expect(newItemResult.isInventory, false);

    await dao.saveToDeleteItemOrInventory(
        item: defaultItem.toDeleteItemEntity());
    final toDeleteItemResult = await dao.getToDeleteItemOrInventory();
    expect(toDeleteItemResult.isInventory, false);

    final items =
        List.generate(9, (index) => index < 3 ? defaultItem : inventory)
            .map((e) => e.toItemsEntity())
            .toList();
    await dao.saveItemsWithInventories(items: items);
    final itemsResult = await dao.getItemsWithInventories();
    expect(itemsResult.length, 9);
    expect(itemsResult.first.isInventory, false);
    expect(itemsResult.last.isInventory, true);
  });
}
