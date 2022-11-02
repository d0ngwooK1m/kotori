import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/util/default_item.dart';
import 'package:kotori/util/result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'adventure_view_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ItemRepository>()])
void main() {
  group('adventure view model test', () {
    test('checkFirstTime test', () async {
      final repository = MockItemRepository();
      final viewModel = AdventureViewModel(repository);
      final items = DefaultItem.firstItemsAndInventories;
      final item = DefaultItem.item;

      when(repository.getItemsWithInventories())
          .thenAnswer((_) async => Result<List<Item>>.success(items));
      when(repository.getNewItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(item));
      when(repository.getToDeleteItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(item));

      await viewModel.checkFirstTime();

      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.items.isNotEmpty, true);
      expect(viewModel.state.newItem.isInventory, false);
      expect(viewModel.state.deleteItem.isInventory, false);

      verify(repository.getItemsWithInventories());
      verify(repository.getNewItemOrInventory());
      verify(repository.getToDeleteItemOrInventory());
    });

    test('setItems test', () async {
      final repository = MockItemRepository();
      final viewModel = AdventureViewModel(repository);
      final items = DefaultItem.firstItemsAndInventories;
      final item = DefaultItem.item;

      when(repository.getItemsWithInventories())
          .thenAnswer((_) async => Result<List<Item>>.success(items));
      when(repository.getNewItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(item));
      when(repository.getToDeleteItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(item));

      await viewModel.checkFirstTime();
      expect(viewModel.state.items.first.isInventory, false);
      expect(viewModel.state.items.last.isInventory, true);

      await viewModel.setItems(viewModel.state.items.first, 0, 8);
      expect(viewModel.state.items.first.isInventory, true);
      expect(viewModel.state.items.last.isInventory, false);

      verify(repository.getItemsWithInventories());
      verify(repository.getNewItemOrInventory());
      verify(repository.getToDeleteItemOrInventory());
    });

    test('newItemToItems test', () async {
      final repository = MockItemRepository();
      final viewModel = AdventureViewModel(repository);
      final items = DefaultItem.firstItemsAndInventories;
      final item = DefaultItem.item;

      when(repository.getItemsWithInventories())
          .thenAnswer((_) async => Result<List<Item>>.success(items));
      when(repository.getNewItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(item));
      when(repository.getToDeleteItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(item));

      await viewModel.checkFirstTime();
      expect(viewModel.state.items.last.isInventory, true);
      expect(viewModel.state.newItem.isInventory, false);

      await viewModel.newItemToItems(viewModel.state.newItem, 8);
      expect(viewModel.state.items.last.isInventory, false);
      expect(viewModel.state.newItem.isInventory, true);

      verify(repository.getItemsWithInventories());
      verify(repository.getNewItemOrInventory());
      verify(repository.getToDeleteItemOrInventory());
    });

    test('itemsToDeleteItem test', () async {
      final repository = MockItemRepository();
      final viewModel = AdventureViewModel(repository);
      final items = DefaultItem.firstItemsAndInventories;
      final item = DefaultItem.item;
      final inventory = DefaultItem.inventory;

      when(repository.getItemsWithInventories())
          .thenAnswer((_) async => Result<List<Item>>.success(items));
      when(repository.getNewItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(item));
      when(repository.getToDeleteItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(inventory));

      await viewModel.checkFirstTime();
      expect(viewModel.state.items.first.isInventory, false);
      expect(viewModel.state.deleteItem.isInventory, true);

      await viewModel.itemsToDeleteItem(item: viewModel.state.items.first, prevPosition: 0);
      expect(viewModel.state.items.first.isInventory, true);
      expect(viewModel.state.deleteItem.isInventory, false);

      verify(repository.getItemsWithInventories());
      verify(repository.getNewItemOrInventory());
      verify(repository.getToDeleteItemOrInventory());
    });

    test('deleteItemToItems test', () async {
      final repository = MockItemRepository();
      final viewModel = AdventureViewModel(repository);
      final items = DefaultItem.firstItemsAndInventories;
      final item = DefaultItem.item;

      when(repository.getItemsWithInventories())
          .thenAnswer((_) async => Result<List<Item>>.success(items));
      when(repository.getNewItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(item));
      when(repository.getToDeleteItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(item));

      await viewModel.checkFirstTime();
      expect(viewModel.state.items.last.isInventory, true);
      expect(viewModel.state.deleteItem.isInventory, false);

      await viewModel.deleteItemToItems(positionTo: 8, item: viewModel.state.deleteItem);
      expect(viewModel.state.items.last.isInventory, false);
      expect(viewModel.state.deleteItem.isInventory, true);

      verify(repository.getItemsWithInventories());
      verify(repository.getNewItemOrInventory());
      verify(repository.getToDeleteItemOrInventory());
    });

    test('newItemToDeleteItem test', () async {
      final repository = MockItemRepository();
      final viewModel = AdventureViewModel(repository);
      final items = DefaultItem.firstItemsAndInventories;
      final item = DefaultItem.item;
      final inventory  = DefaultItem.inventory;

      when(repository.getItemsWithInventories())
          .thenAnswer((_) async => Result<List<Item>>.success(items));
      when(repository.getNewItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(item));
      when(repository.getToDeleteItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(inventory));

      await viewModel.checkFirstTime();
      expect(viewModel.state.newItem.isInventory, false);
      expect(viewModel.state.deleteItem.isInventory, true);

      await viewModel.newItemToDeleteItem(viewModel.state.newItem);
      expect(viewModel.state.newItem.isInventory, true);
      expect(viewModel.state.deleteItem.isInventory, false);

      verify(repository.getItemsWithInventories());
      verify(repository.getNewItemOrInventory());
      verify(repository.getToDeleteItemOrInventory());
    });

    test('checkProcess and completeProcess test', () async {
      final repository = MockItemRepository();
      final viewModel = AdventureViewModel(repository);
      final items = DefaultItem.firstItemsAndInventories;
      final inventory = DefaultItem.inventory;

      when(repository.getItemsWithInventories())
          .thenAnswer((_) async => Result<List<Item>>.success(items));
      when(repository.getNewItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(inventory));
      when(repository.getToDeleteItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(inventory));

      await viewModel.checkFirstTime();
      expect(viewModel.state.isOkayToProcess, false);

      await viewModel.itemsToDeleteItem(item: viewModel.state.items.first, prevPosition: 0);
      await viewModel.checkProcess();
      expect(viewModel.state.isOkayToProcess, true);

      await viewModel.completeProcess();
      expect(viewModel.state.isOkayToProcess, false);

      verify(repository.getItemsWithInventories());
      verify(repository.getNewItemOrInventory());
      verify(repository.getToDeleteItemOrInventory());
    });

    test('saveEveryItemOrInventory test', () async {
      final repository = MockItemRepository();
      final viewModel = AdventureViewModel(repository);
      final items = DefaultItem.firstItemsAndInventories;
      final inventory = DefaultItem.inventory;

      when(repository.getItemsWithInventories())
          .thenAnswer((_) async => Result<List<Item>>.success(items));
      when(repository.getNewItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(inventory));
      when(repository.getToDeleteItemOrInventory())
          .thenAnswer((_) async => Result<Item>.success(inventory));

      await viewModel.checkFirstTime();
      expect(viewModel.state.message, null);

      verify(repository.getItemsWithInventories());
      verify(repository.getNewItemOrInventory());
      verify(repository.getToDeleteItemOrInventory());

      when(repository.saveItemsWithInventories(items: anyNamed('items'))).thenAnswer((_) async => const Result.success(null));
      when(repository.saveNewItemOrInventory(item: anyNamed('item'))).thenAnswer((_) async => const Result.success(null));
      when(repository.saveToDeleteItemOrInventory(item: anyNamed('item'))).thenAnswer((_) async => const Result.success(null));

      await viewModel.saveEveryItemOrInventory(items: items, newItem: inventory, toDeleteItem: inventory);
      expect(viewModel.state.message, null);

      verify(repository.saveItemsWithInventories(items: anyNamed('items')));
      verify(repository.saveNewItemOrInventory(item: anyNamed('item')));
      verify(repository.saveToDeleteItemOrInventory(item: anyNamed('item')));
    });
  });
}
