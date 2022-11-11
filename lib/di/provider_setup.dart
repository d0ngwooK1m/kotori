import 'package:hive/hive.dart';
import 'package:kotori/data/repository/diary_repository_impl.dart';
import 'package:kotori/data/repository/item_repository_impl.dart';
import 'package:kotori/data/source/diary/diary_dao_impl.dart';
import 'package:kotori/data/source/diary/diary_entity.dart';
import 'package:kotori/data/source/item/item_dao_impl.dart';
import 'package:kotori/data/source/item/items_entity.dart';
import 'package:kotori/data/source/item/new_item_entity.dart';
import 'package:kotori/data/source/item/to_delete_item_entity.dart';
import 'package:kotori/domain/use_case/adventure_use_cases.dart';
import 'package:kotori/domain/use_case/daily_diary_use_cases.dart';
import 'package:kotori/domain/use_case/diary/get_diary_use_case.dart';
import 'package:kotori/domain/use_case/diary/is_okay_to_make_item_use_case.dart';
import 'package:kotori/domain/use_case/diary/save_diary_use_case.dart';
import 'package:kotori/domain/use_case/item/get_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/get_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/get_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/save_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/save_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/save_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/daily_diary/daily_diary_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<List<SingleChildWidget>> getProviders() async {
  final diaryBox = await Hive.openBox<DiaryEntity>('daily_diary.db');
  final itemsBox = await Hive.openBox<ItemsEntity>('items.db');
  final newItemBox = await Hive.openBox<NewItemEntity>('new_item.db');
  final toDeleteItemBox =
      await Hive.openBox<ToDeleteItemEntity>('to_delete_item.db');

  final diaryDao = DiaryDaoImpl(diaryBox);
  final itemDao = ItemDaoImpl(
    itemsBox: itemsBox,
    newItemBox: newItemBox,
    toDeleteItemBox: toDeleteItemBox,
  );

  final diaryRepository = DiaryRepositoryImpl(diaryDao);
  final itemRepository = ItemRepositoryImpl(itemDao);

  final itemUseCases = AdventureUseCases(
    GetItemsWithInventoriesUseCase(itemRepository),
    GetNewItemOrInventoryUseCase(itemRepository),
    GetToDeleteItemOrInventoryUseCase(itemRepository),
    SaveItemsWithInventoriesUseCase(itemRepository),
    SaveNewItemOrInventoryUseCase(itemRepository),
    SaveToDeleteItemOrInventoryUseCase(itemRepository),
    IsOkayToMakeNewItemUseCase(diaryRepository),
  );
  final dailyDiaryUseCases = DailyDiaryUseCases(
    GetDiaryUseCase(diaryRepository),
    SaveDiaryUseCase(diaryRepository),
  );

  final adventureViewModel = AdventureViewModel(itemUseCases);
  final dailyDiaryViewModel = DailyDiaryViewModel(dailyDiaryUseCases);

  return [
    ChangeNotifierProvider(create: (_) => dailyDiaryViewModel),
    ChangeNotifierProvider(create: (_) => adventureViewModel),
  ];
}
