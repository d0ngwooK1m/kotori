import 'package:hive/hive.dart';
import 'package:kotori/data/repository/diary_repository_impl.dart';
import 'package:kotori/data/repository/item_repository_impl.dart';
import 'package:kotori/data/source/diary/diary_dao_impl.dart';
import 'package:kotori/data/source/diary/diary_entity.dart';
import 'package:kotori/data/source/item/item_dao_impl.dart';
import 'package:kotori/data/source/item/items_entity.dart';
import 'package:kotori/data/source/item/new_item_entity.dart';
import 'package:kotori/data/source/item/to_delete_item_entity.dart';
import 'package:kotori/domain/use_case/item/get_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/get_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/get_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/item_use_cases.dart';
import 'package:kotori/domain/use_case/item/save_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/save_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/save_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/diary/diary_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<List<SingleChildWidget>> getProviders() async {
  final diaryBox = await Hive.openBox<DiaryEntity>('diary.db');
  final itemsBox = await Hive.openBox<ItemsEntity>('items.db');
  final newItemBox = await Hive.openBox<NewItemEntity>('new_item.db');
  final toDeleteItemBox = await Hive.openBox<ToDeleteItemEntity>(
      'to_delete_item.db');

  final diaryDao = DiaryDaoImpl(diaryBox);
  final itemDao = ItemDaoImpl(
    itemsBox: itemsBox,
    newItemBox: newItemBox,
    toDeleteItemBox: toDeleteItemBox,
  );

  final diaryRepository = DiaryRepositoryImpl(diaryDao);
  final itemRepository = ItemRepositoryImpl(itemDao);

  final diaryViewModel = DiaryViewModel(diaryRepository);
  final itemUseCases = ItemUseCases(
      getItemsWithInventoriesUseCase: GetItemsWithInventoriesUseCase(itemRepository),
      getNewItemOrInventoryUseCase: GetNewItemOrInventoryUseCase(itemRepository),
      getToDeleteItemOrInventoryUseCase: GetToDeleteItemOrInventoryUseCase(itemRepository),
      saveItemsWithInventoriesUseCase: SaveItemsWithInventoriesUseCase(itemRepository),
      saveNewItemOrInventoryUseCase: SaveNewItemOrInventoryUseCase(itemRepository),
      saveToDeleteItemOrInventoryUseCase: SaveToDeleteItemOrInventoryUseCase(itemRepository),
  );
  final adventureViewModel = AdventureViewModel(itemUseCases);

  return [
    ChangeNotifierProvider(create: (_) => diaryViewModel),
    ChangeNotifierProvider(create: (_) => adventureViewModel),
  ];
}
