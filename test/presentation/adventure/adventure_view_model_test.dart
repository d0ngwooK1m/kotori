import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/use_case/diary/is_okay_to_make_or_use_item_use_case.dart';
import 'package:kotori/domain/use_case/item/get_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/get_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/get_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/adventure_use_cases.dart';
import 'package:kotori/domain/use_case/item/save_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/save_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/save_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/util/default_item.dart';
import 'package:kotori/util/result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'adventure_view_model_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetItemsWithInventoriesUseCase>(),
  MockSpec<GetNewItemOrInventoryUseCase>(),
  MockSpec<GetToDeleteItemOrInventoryUseCase>(),
  MockSpec<SaveItemsWithInventoriesUseCase>(),
  MockSpec<SaveNewItemOrInventoryUseCase>(),
  MockSpec<SaveToDeleteItemOrInventoryUseCase>(),
  MockSpec<IsOkayToMakeOrUseItemUseCase>(),
])
void main() {
  group('adventure view model test', () {
    final fakeGetItems = MockGetItemsWithInventoriesUseCase();
    final fakeGetNewItem = MockGetNewItemOrInventoryUseCase();
    final fakeGetToDeleteItem = MockGetToDeleteItemOrInventoryUseCase();
    final saveFakeItems = MockSaveItemsWithInventoriesUseCase();
    final saveFakeNewItem = MockSaveNewItemOrInventoryUseCase();
    final saveFakeToDeleteItem = MockSaveToDeleteItemOrInventoryUseCase();
    final fakeIsOkayToMakeNewItem = MockIsOkayToMakeOrUseItemUseCase();



    final useCases = AdventureUseCases(
      fakeGetItems,
      fakeGetNewItem,
      fakeGetToDeleteItem,
      saveFakeItems,
      saveFakeNewItem,
      saveFakeToDeleteItem,
      fakeIsOkayToMakeNewItem,
    );
    final viewModel = AdventureViewModel(useCases);
    final items = DefaultItem.firstItemsAndInventories;
    final item = DefaultItem.item;
    final inventory = DefaultItem.inventory;

    when(fakeGetItems())
        .thenAnswer((_) async => Result<List<Item>>.success(items));
    when(fakeGetNewItem()).thenAnswer((_) async => Result<Item>.success(inventory));
    when(fakeGetToDeleteItem())
        .thenAnswer((_) async => Result<Item>.success(inventory));

    test('checkFirstTime test', () async {
      await viewModel.checkFirstTime();

      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.items.isNotEmpty, true);
      expect(viewModel.state.newItem!.isInventory, true);
      expect(viewModel.state.deleteItem!.isInventory, true);

      verify(fakeGetItems());
      verify(fakeGetNewItem());
      verify(fakeGetToDeleteItem());
    });

    test('checkNewItemGenerate test', () async {
      when(fakeIsOkayToMakeNewItem()).thenAnswer((_) async => const Result.success(true));

      await viewModel.checkIsOkayToMakeOrUseItem();
      expect(viewModel.state.newItem!.isInventory, false);

      verify(fakeIsOkayToMakeNewItem());
    });

    test('setItems test', () async {
      await viewModel.checkFirstTime();
      expect(viewModel.state.items.first.isInventory, false);
      expect(viewModel.state.items.last.isInventory, true);

      await viewModel.setItems(viewModel.state.items.first, 0, 8);
      expect(viewModel.state.items.first.isInventory, true);
      expect(viewModel.state.items.last.isInventory, false);

      verify(fakeGetItems());
      verify(fakeGetNewItem());
      verify(fakeGetToDeleteItem());
    });

    test('newItemToItems test', () async {
      when(fakeGetItems())
          .thenAnswer((_) async => Result<List<Item>>.success(items));
      when(fakeGetNewItem()).thenAnswer((_) async => Result<Item>.success(item));
      when(fakeGetToDeleteItem())
          .thenAnswer((_) async => Result<Item>.success(inventory));

      await viewModel.checkFirstTime();
      expect(viewModel.state.items.last.isInventory, true);
      expect(viewModel.state.newItem!.isInventory, false);

      await viewModel.newItemToItems(viewModel.state.newItem!, 8);
      expect(viewModel.state.items.last.isInventory, false);
      expect(viewModel.state.newItem!.isInventory, true);

      verify(fakeGetItems());
      verify(fakeGetNewItem());
      verify(fakeGetToDeleteItem());
    });

    test('itemsToDeleteItem test', () async {
      await viewModel.checkFirstTime();
      expect(viewModel.state.items.first.isInventory, false);
      expect(viewModel.state.deleteItem!.isInventory, true);

      await viewModel.itemsToDeleteItem(
          item: viewModel.state.items.first, prevPosition: 0);
      expect(viewModel.state.items.first.isInventory, true);
      expect(viewModel.state.deleteItem!.isInventory, false);

      verify(fakeGetItems());
      verify(fakeGetNewItem());
      verify(fakeGetToDeleteItem());
    });

    test('deleteItemToItems test', () async {
      when(fakeGetItems())
          .thenAnswer((_) async => Result<List<Item>>.success(items));
      when(fakeGetNewItem()).thenAnswer((_) async => Result<Item>.success(inventory));
      when(fakeGetToDeleteItem())
          .thenAnswer((_) async => Result<Item>.success(item));
      await viewModel.checkFirstTime();
      expect(viewModel.state.items.last.isInventory, true);
      expect(viewModel.state.deleteItem!.isInventory, false);

      await viewModel.deleteItemToItems(
          positionTo: 8, item: viewModel.state.deleteItem!);
      expect(viewModel.state.items.last.isInventory, false);
      expect(viewModel.state.deleteItem!.isInventory, true);

      verify(fakeGetItems());
      verify(fakeGetNewItem());
      verify(fakeGetToDeleteItem());
    });

    test('newItemToDeleteItem test', () async {
      when(fakeGetItems())
          .thenAnswer((_) async => Result<List<Item>>.success(items));
      when(fakeGetNewItem()).thenAnswer((_) async => Result<Item>.success(item));
      when(fakeGetToDeleteItem())
          .thenAnswer((_) async => Result<Item>.success(inventory));

      await viewModel.checkFirstTime();
      expect(viewModel.state.newItem!.isInventory, false);
      expect(viewModel.state.deleteItem!.isInventory, true);

      await viewModel.newItemToDeleteItem(viewModel.state.newItem!);
      expect(viewModel.state.newItem!.isInventory, true);
      expect(viewModel.state.deleteItem!.isInventory, false);

      verify(fakeGetItems());
      verify(fakeGetNewItem());
      verify(fakeGetToDeleteItem());
    });


    test('saveEveryItemOrInventory test', () async {
      await viewModel.checkFirstTime();
      expect(viewModel.state.message, null);

      verify(fakeGetItems());
      verify(fakeGetNewItem());
      verify(fakeGetToDeleteItem());

      when(saveFakeItems(items: anyNamed('items')))
          .thenAnswer((_) async => const Result.success(null));
      when(saveFakeNewItem(item: anyNamed('item')))
          .thenAnswer((_) async => const Result.success(null));
      when(saveFakeToDeleteItem(item: anyNamed('item')))
          .thenAnswer((_) async => const Result.success(null));

      await viewModel.saveEveryItemOrInventory(
          items: items, newItem: inventory, toDeleteItem: inventory);
      expect(viewModel.state.message, null);

      verify(saveFakeItems(items: anyNamed('items')));
      verify(saveFakeNewItem(item: anyNamed('item')));
      verify(saveFakeToDeleteItem(item: anyNamed('item')));
    });
  });
}
