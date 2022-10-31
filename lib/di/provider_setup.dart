import 'package:hive/hive.dart';
import 'package:kotori/data/repository/diary_repository_impl.dart';
import 'package:kotori/data/repository/item_repository_impl.dart';
import 'package:kotori/data/source/diary/diary_dao_impl.dart';
import 'package:kotori/data/source/diary/diary_entity.dart';
import 'package:kotori/data/source/item/item_dao_impl.dart';
import 'package:kotori/data/source/item/items_entity.dart';
import 'package:kotori/data/source/item/new_item_entity.dart';
import 'package:kotori/data/source/item/to_delete_item_entity.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/diary/diary_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<List<SingleChildWidget>> getProviders() async {
  final diaryBox = await Hive.openBox<DiaryEntity>('diary.db');
  final itemsBox = await Hive.openBox<ItemsEntity>('items.db');
  final newItemBox = await Hive.openBox<NewItemEntity>('new_item.db');
  final toDeleteItemBox = await Hive.openBox<ToDeleteItemEntity>('to_delete_item.db');

  final diaryDao = DiaryDaoImpl(diaryBox);
  final itemDao = ItemDaoImpl(
    itemsBox: itemsBox,
    newItemBox: newItemBox,
    toDeleteItemBox: toDeleteItemBox,
  );

  final diaryRepository = DiaryRepositoryImpl(diaryDao);
  final itemRepository = ItemRepositoryImpl(itemDao);

  final diaryViewModel = DiaryViewModel(diaryRepository);
  final adventureViewModel = AdventureViewModel(itemRepository);

  return [
    ChangeNotifierProvider(create: (_) => diaryViewModel),
    ChangeNotifierProvider(create: (_) => adventureViewModel),
  ];
}
