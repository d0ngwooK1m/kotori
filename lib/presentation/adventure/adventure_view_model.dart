import 'package:flutter/material.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/presentation/adventure/adventure_state.dart';

class AdventureViewModel extends ChangeNotifier {
  final ItemRepository repository;

  final _state = AdventureState();

  AdventureState get state => _state;

  AdventureViewModel(this.repository);

  void getNewItem() async {
    state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.getNewItem();
    result.when(
      success: (item) {
        state.copyWith(isLoading: false, newItem: item);
      },
      error: (e) {
        state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  void getAllItems() async {
    state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.getAllItems();
    result.when(
      success: (items) {
        state.copyWith(isLoading: false, items: items);
      },
      error: (e) {
        state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  void updateAllItems(List<Item> items) async {
    state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.updateAllItems(items);
    result.when(
      success: (items) {
        state.copyWith(isLoading: false, items: items);
      },
      error: (e) {
        state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }

  void deleteItem(Item item) async {
    state.copyWith(isLoading: true);
    notifyListeners();

    final result = await repository.deleteItem(item);
    result.when(
      success: (success) {
        state.copyWith(isLoading: false, message: success);
      },
      error: (e) {
        state.copyWith(isLoading: false, message: e.toString());
      },
    );
    notifyListeners();
  }
}
