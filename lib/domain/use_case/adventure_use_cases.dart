import 'package:kotori/domain/use_case/diary/is_okay_to_make_or_use_item_use_case.dart';
import 'package:kotori/domain/use_case/item/get_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/get_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/get_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/save_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/save_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/save_to_delete_item_or_inventory_use_case.dart';

class AdventureUseCases {
  final GetItemsWithInventoriesUseCase getItemsWithInventoriesUseCase;
  final GetNewItemOrInventoryUseCase getNewItemOrInventoryUseCase;
  final GetToDeleteItemOrInventoryUseCase getToDeleteItemOrInventoryUseCase;
  final SaveItemsWithInventoriesUseCase saveItemsWithInventoriesUseCase;
  final SaveNewItemOrInventoryUseCase saveNewItemOrInventoryUseCase;
  final SaveToDeleteItemOrInventoryUseCase saveToDeleteItemOrInventoryUseCase;
  final IsOkayToMakeOrUseItemUseCase isOkayToMakeOrUseItemUseCase;

  AdventureUseCases(
    this.getItemsWithInventoriesUseCase,
    this.getNewItemOrInventoryUseCase,
    this.getToDeleteItemOrInventoryUseCase,
    this.saveItemsWithInventoriesUseCase,
    this.saveNewItemOrInventoryUseCase,
    this.saveToDeleteItemOrInventoryUseCase,
    this.isOkayToMakeOrUseItemUseCase,
  );
}
