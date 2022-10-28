import 'package:flutter/material.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/presentation/adventure/adventure_state.dart';
import 'package:kotori/util/time.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdventureViewModel extends ChangeNotifier {
  final ItemRepository repository;

  var _state = AdventureState();

  AdventureState get state => _state;

  AdventureViewModel(this.repository) {
    checkFirstTime();
  }

  Future<void> addItemToItems({List<Item>? items}) async {
    final result = await repository.addItemToItems(items: items);
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

  Future<void> deleteItemFromItems({required Item item}) async {
    final result = await repository.deleteItemFromItems(item: item);
    result.when(
      success: (data) {
        _state = state.copyWith(isLoading: false, items: data, message: null);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  Future<void> addNewItem() async {
    final result = await repository.addNewItem();
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

  Future<void> deleteNewItem() async {
    final result = await repository.deleteNewItem();
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

  Future<void> addToDeleteItem({required Item item}) async {
    final result = await repository.addToDeleteItem(item: item);
    result.when(
      success: (data) {
        _state = state.copyWith(isLoading: false, deleteItem: data, message: null);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  Future<void> deleteToDeleteItem() async {
    final result = await repository.deleteToDeleteItem();
    result.when(
      success: (data) {
        _state = state.copyWith(isLoading: false, deleteItem: data, message: null);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
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
    await addItemToItems(items: firstItemList);
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
      await deleteNewItem();
      await addItemToItems(items: inventoryItemList);
    }
  }

  Future<void> itemsToDeleteItem(Item item) async {
    List<Item> inventoryItemList = [];
    for (var element in state.items) {
      inventoryItemList.add(element);
    }
    Item? toDeleteItem;
    final items = inventoryItemList
        .map((target) {
          if (target.date == item.date) {
            toDeleteItem = target;
            return Item(
              name: '',
              desc: '',
              picture: '',
              date: Time.now,
              isInventory: true,
            );
          } else {
            return target;
          }
        })
        .toList();
    if (toDeleteItem != null) {
      await addItemToItems(items: items);
      await addToDeleteItem(item: toDeleteItem!);
    }
  }

  Future<void> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      await addItemToItems(items: null);
    } else {
      prefs.setBool('first_time', false);
      await getFirstTimeItems();
    }
  }
}
