import 'package:flutter/material.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/use_case/adventure_use_cases.dart';
import 'package:kotori/presentation/adventure/adventure_state.dart';
import 'package:kotori/util/default_item.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdventureViewModel extends ChangeNotifier {
  final AdventureUseCases useCases;
  AdventureState _state = AdventureState();

  AdventureState get state => _state;

  AdventureViewModel(this.useCases);

  final inventory = DefaultItem.inventory;
  final newItem = DefaultItem.item;

  Future<void> getEveryItemOrInventory() async {
    final result = await useCases.getItemsWithInventoriesUseCase();
    final newItem = await useCases.getNewItemOrInventoryUseCase();
    final deleteItem = await useCases.getToDeleteItemOrInventoryUseCase();
    result.when(
      success: (data) {
        _state = state.copyWith(isLoading: false, items: data, message: null);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    newItem.when(
      success: (data) {
        _state = state.copyWith(isLoading: false, newItem: data, message: null);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    deleteItem.when(
      success: (data) {
        _state = state.copyWith(isLoading: false, deleteItem: data, message: null);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  Future<void> saveEveryItemOrInventory({
    required List<Item> items,
    required Item newItem,
    required Item toDeleteItem,
  }) async {
    final result = await useCases.saveItemsWithInventoriesUseCase(items: items);
    final newItemResult =
        await useCases.saveNewItemOrInventoryUseCase(item: newItem);
    final deleteItemResult =
        await useCases.saveToDeleteItemOrInventoryUseCase(item: toDeleteItem);
    _setStateResultWithVoid(result);
    _setStateResultWithVoid(newItemResult);
    _setStateResultWithVoid(deleteItemResult);
    notifyListeners();
  }

  Future<void> getFirstTimeItems() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    _state = state.copyWith(
      isLoading: false,
      items: DefaultItem.firstItemsAndInventories,
      newItem: inventory,
      deleteItem: inventory,
    );
    notifyListeners();
  }

  Future<void> setItems(Item item, int? positionNow, int? positionTo) async {
    List<Item> inventoryItemList = [];
    for (var element in state.items) {
      inventoryItemList.add(element);
    }
    if (positionNow != null && positionTo != null) {
      final temp = inventoryItemList[positionTo];
      inventoryItemList[positionTo] = item;
      inventoryItemList[positionNow] = temp;
    }

    _state = state.copyWith(items: inventoryItemList);
    notifyListeners();
  }

  Future<void> newItemToItems(Item item, int? positionTo) async {
    List<Item> inventoryItemList = [];
    for (var element in state.items) {
      inventoryItemList.add(element);
    }

    if (positionTo != null && inventoryItemList[positionTo].isInventory) {
      inventoryItemList[positionTo] = item;
      _state = state.copyWith(items: inventoryItemList, newItem: inventory);
      notifyListeners();
    }
  }

  Future<void> itemsToDeleteItem(
      {required Item item, required int prevPosition}) async {
    List<Item> inventoryItemList = [];
    for (var element in state.items) {
      inventoryItemList.add(element);
    }
    if (state.deleteItem!.isInventory) {
      inventoryItemList[prevPosition] = inventory;
      _state = state.copyWith(deleteItem: item, items: inventoryItemList);
    } else {
      final temp = inventoryItemList[prevPosition];
      inventoryItemList[prevPosition] = item;
      _state = state.copyWith(deleteItem: temp, items: inventoryItemList);
    }
    notifyListeners();
  }

  Future<void> deleteItemToItems(
      {required int positionTo, required Item item}) async {
    List<Item> inventoryItemList = [];
    for (var element in state.items) {
      inventoryItemList.add(element);
    }
    if (inventoryItemList[positionTo].isInventory) {
      inventoryItemList[positionTo] = item;
      _state = state.copyWith(items: inventoryItemList, deleteItem: inventory);
    } else {
      final temp = inventoryItemList[positionTo];
      inventoryItemList[positionTo] = item;
      _state = state.copyWith(items: inventoryItemList, deleteItem: temp);
    }
    notifyListeners();
  }

  Future<void> newItemToDeleteItem(Item item) async {
    if (state.deleteItem!.isInventory) {
      _state = state.copyWith(newItem: inventory, deleteItem: item);
    }
    notifyListeners();
  }

  Future<void> itemsToUseItem(int position, Item item) async {
    List<Item> inventoryItemList = [];
    for (var element in state.items) {
      inventoryItemList.add(element);
    }
    inventoryItemList[position] = inventory;
    _state = state.copyWith(items: inventoryItemList, isOkayToUse: true);
    notifyListeners();
  }

  Future<void> checkIsOkayToDelete() async {
    _state = state.copyWith(isOkayToDelete: true);
    notifyListeners();
  }

  Future<void> completeIsOkayToDelete() async {
    _state = state.copyWith(deleteItem: inventory, isOkayToDelete: false);
    notifyListeners();
  }

  Future<void> checkIsOkayToUse() async {
    _state = state.copyWith(isOkayToUse: true);
    notifyListeners();
  }

  Future<void> completeIsOkayToUse() async {
    _state = state.copyWith(isOkayToUse: false);
    notifyListeners();
  }

  Future<void> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      await getEveryItemOrInventory();
    } else {
      prefs.setBool('first_time', false);
      prefs.setInt('first_date_epoch', Time.now.millisecondsSinceEpoch);
      await getFirstTimeItems();
    }
  }

  void _setStateResultWithVoid(Result result) {
    result.when(
      success: (none) {
        _state = state.copyWith(isLoading: false, message: null);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
  }

  Future<void> checkIsOkayToMakeOrUseItem() async {
    bool isItemAlreadyExist = false;
    final newItem = state.newItem ?? DefaultItem.inventory;
    final toDeleteItem = state.deleteItem ?? DefaultItem.inventory;

    for (var element in state.items) {
      if (!element.isInventory && element.date == Time.now) {
        isItemAlreadyExist = true;
      }
    }
    if ((!newItem.isInventory &&
            newItem.date == Time.now) ||
        (!toDeleteItem.isInventory &&
            toDeleteItem.date == Time.now)) {
      isItemAlreadyExist = true;
    }
    if (!isItemAlreadyExist) {
      final result = await useCases.isOkayToMakeOrUseItemUseCase();
      result.when(
        success: (data) async {
          if (data == true) {
            _state = state.copyWith(newItem: DefaultItem.item, isOkayToUse: false, message: null);
          } else if (data == false) {
            _state = state.copyWith(isOkayToUse: true, message: null);
          } else {
            _state = state.copyWith(isOkayToUse: false, message: null);
          }
        },
        error: (e) {
          _state = state.copyWith(message: e.toString());
        },
      );
      notifyListeners();
    }
  }

  Future<void> saveItemInfo({required Item item, required int position}) async {
    List<Item> inventoryItemList = [];
    for (var element in state.items) {
      inventoryItemList.add(element);
    }

    inventoryItemList[position] = item;

    _state = state.copyWith(items: inventoryItemList);
    notifyListeners();
  }
}
