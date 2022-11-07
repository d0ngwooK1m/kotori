import 'package:kotori/domain/use_case/item/get_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/get_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/get_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/save_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/save_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/save_to_delete_item_or_inventory_use_case.dart';

class ItemUseCases {
  final GetItemsWithInventoriesUseCase getItemsWithInventoriesUseCase;
  final GetNewItemOrInventoryUseCase getNewItemOrInventoryUseCase;
  final GetToDeleteItemOrInventoryUseCase getToDeleteItemOrInventoryUseCase;
  final SaveItemsWithInventoriesUseCase saveItemsWithInventoriesUseCase;
  final SaveNewItemOrInventoryUseCase saveNewItemOrInventoryUseCase;
  final SaveToDeleteItemOrInventoryUseCase saveToDeleteItemOrInventoryUseCase;

  ItemUseCases(
    this.getItemsWithInventoriesUseCase,
    this.getNewItemOrInventoryUseCase,
    this.getToDeleteItemOrInventoryUseCase,
    this.saveItemsWithInventoriesUseCase,
    this.saveNewItemOrInventoryUseCase,
    this.saveToDeleteItemOrInventoryUseCase,
  );
}
