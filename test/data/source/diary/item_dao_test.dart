import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:kotori/data/source/item/item_dao_impl.dart';
import 'package:kotori/data/source/item/item_entity.dart';
import 'package:kotori/util/time.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  test('item_dao test', () async {
    final dir = await getApplicationDocumentsDirectory();
    Hive
      ..init(dir.path)
      ..registerAdapter(ItemEntityAdapter());
    final box = await Hive.openBox<ItemEntity>('test_items.db');
    await box.clear();
    final dao = ItemDaoImpl(box);

    final item = await dao.getNewItem();
    expect(item.date, Time.now);

    final items = await dao.updateAllItems(items: [item]);
    expect(items.length, 1);

    final allItems = await dao.getAllItems();
    expect(allItems.first.date, Time.now);

    await dao.deleteItem(item: item);
    expect(box.values.length, 0);
  });
}
