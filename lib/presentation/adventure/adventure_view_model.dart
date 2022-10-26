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

  Future<void> getNewItem() async {
    final result = await repository.getNewItem();
    result.when(
      success: (item) {
        _state = state.copyWith(isLoading: false, newItem: item);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  Future<void> getAllItems() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.getAllItems();
    result.when(
      success: (items) {
        _state = state.copyWith(isLoading: false, items: items);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  Future<void> updateAllItems(List<Item> items, Item? newItem) async {
    final result = await repository.updateAllItems(items: items);
    result.when(
      success: (items) {
        if (newItem == null) {
          _state = state.copyWith(
              isLoading: false, items: items, newItem: null, deleteItem: null);
        } else {
          _state = state.copyWith(
              isLoading: false, items: items, newItem: newItem, deleteItem: null);
        }
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  Future<void> deleteItem(Item item) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.deleteItem(item: item);
    result.when(
      success: (success) {
        _state = state.copyWith(isLoading: false, message: success);
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
    await getNewItem();
    await updateAllItems(firstItemList, state.newItem);
    notifyListeners();
  }

  Future<void> setItems(Item item, int? positionNow, int positionTo) async {
    List<Item> inventoryItemList = [];
    for (var element in state.items) {
      inventoryItemList.add(element);
    }
    if (positionNow == null && inventoryItemList[positionTo].isInventory) {
      inventoryItemList[positionTo] = item;
      _state = state.copyWith(newItem: null);
      notifyListeners();
    } else if (positionNow != null) {
      final temp = inventoryItemList[positionTo];
      inventoryItemList[positionTo] = item;
      inventoryItemList[positionNow] = temp;
    }
    await updateAllItems(inventoryItemList, state.newItem);
  }

  Future<void> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      await getAllItems();
    } else {
      prefs.setBool('first_time', false);
      await getFirstTimeItems();
    }
  }
}
