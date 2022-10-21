import 'package:flutter/material.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/presentation/adventure/adventure_state.dart';

class AdventureViewModel extends ChangeNotifier {
  final ItemRepository repository;

  var _state = AdventureState();

  AdventureState get state => _state;

  AdventureViewModel(this.repository);

  void getNewItem() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

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

  void getAllItems() async {
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

  void updateAllItems(List<Item> items) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.updateAllItems(items: items);
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

  void deleteItem(Item item) async {
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
}
