import 'package:flutter/material.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/presentation/adventure/adventure_state.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdventureViewModel extends ChangeNotifier {
  final ItemRepository repository;

  var _state = AdventureState();

  AdventureState get state => _state;

  AdventureViewModel(this.repository) {
    checkFirstTime();
  }

  final inventory = Item(name: '', desc: '', picture: '', date: Time.now, isInventory: true);
  final newItem = Item(name: '', desc: '', picture: '', date: Time.now);

  Future<void> getItemsWithInventories() async {
    final result = await repository.getItemsWithInventories();
    result.when(
      success: (data) async {
        _state = state.copyWith(isLoading: false, items: data, message: null);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  Future<void> saveItemsWithInventories({required List<Item> items}) async {
    final result = await repository.saveItemsWithInventories(items: items);
    setStateResultWithVoid(result);
  }

  Future<void> getNewItemOrInventory() async {
    final result = await repository.getNewItemOrInventory();
    result.when(
      success: (data) {
        _state = state.copyWith(isLoading: false, newItem: data, message: null);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  Future<void> saveNewItemOrInventory({required Item item}) async {
    final result = await repository.saveNewItemOrInventory(item: item);
    setStateResultWithVoid(result);
  }

  Future<void> getToDeleteItemOrInventory() async {
    final result = await repository.getToDeleteItemOrInventory();
    result.when(
      success: (data) {
        _state =
            state.copyWith(isLoading: false, deleteItem: data, message: null);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  Future<void> saveToDeleteItemOrInventory({required Item item}) async {
    final result = await repository.saveToDeleteItemOrInventory(item: item);
    setStateResultWithVoid(result);
  }

  Future<void> getFirstTimeItems() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    final firstItemList = List<Item>.generate(
        9,
        (index) => index < 3
            ? Item(name: '', desc: '', picture: '', date: Time.now)
            : Item(
                name: '',
                desc: '',
                picture: '',
                date: Time.now,
                isInventory: true));
    _state = state.copyWith(isLoading: false, items: firstItemList);
    notifyListeners();
  }

  Future<void> setItems(Item item, int positionNow, int positionTo) async {
    List<Item> inventoryItemList = [];
    for (var element in state.items) {
      inventoryItemList.add(element);
    }
    final temp = inventoryItemList[positionTo];
    inventoryItemList[positionTo] = item;
    inventoryItemList[positionNow] = temp;

    _state = state.copyWith(items: inventoryItemList);
    notifyListeners();
  }

  Future<void> newItemToItems(Item item, int positionTo) async {
    List<Item> inventoryItemList = [];
    for (var element in state.items) {
      inventoryItemList.add(element);
    }

    if (inventoryItemList[positionTo].isInventory) {
      inventoryItemList[positionTo] = item;
      _state = state.copyWith(items: inventoryItemList, newItem: inventory);
      notifyListeners();
    }
  }

  Future<void> itemsToDeleteItem(Item item) async {
    List<Item> inventoryItemList = [];
    for (var element in state.items) {
      inventoryItemList.add(element);
    }
    Item? toDeleteItem;
    final items = inventoryItemList.map((target) {
      if (target.date == item.date) {
        toDeleteItem = target;
        return inventory;
      } else {
        return target;
      }
    }).toList();
    if (toDeleteItem != null) {
      _state = state.copyWith(deleteItem: toDeleteItem, items: items);
      notifyListeners();
    }
  }

  Future<void> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      await getItemsWithInventories();
    } else {
      prefs.setBool('first_time', false);
      await getFirstTimeItems();
    }
  }

  void setStateResultWithVoid(Result result) {
    result.when(
      success: (none) {
        _state = state.copyWith(isLoading: false, message: null);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }
}
