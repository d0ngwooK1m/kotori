import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:kotori/data/source/item/item_entity.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  test('item_dao test', () async {
    final dir = await getApplicationDocumentsDirectory();
    Hive
      ..init(dir.path)
      ..registerAdapter(ItemEntityAdapter());
    // final box =

  });
}