import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/use_case/item/get_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/get_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/get_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/item_use_cases.dart';
import 'package:kotori/domain/use_case/item/save_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/save_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/save_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/presentation/adventure/adventure_screen.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/adventure/components/drag_target_inventory.dart';
import 'package:kotori/presentation/adventure/components/draggable_item.dart';
import 'package:kotori/util/default_item.dart';
import 'package:kotori/util/key_and_string.dart';
import 'package:kotori/util/modal_route_observer.dart';
import 'package:kotori/util/result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'adventure_screen_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetItemsWithInventoriesUseCase>(),
  MockSpec<GetNewItemOrInventoryUseCase>(),
  MockSpec<GetToDeleteItemOrInventoryUseCase>(),
  MockSpec<SaveItemsWithInventoriesUseCase>(),
  MockSpec<SaveNewItemOrInventoryUseCase>(),
  MockSpec<SaveToDeleteItemOrInventoryUseCase>(),
])
void main() {
  Future<void> _pumpTestWidget(WidgetTester tester) async {
    final fakeGetItems = MockGetItemsWithInventoriesUseCase();
    final fakeGetNewItem = MockGetNewItemOrInventoryUseCase();
    final fakeGetToDeleteItem = MockGetToDeleteItemOrInventoryUseCase();
    final saveFakeItems = MockSaveItemsWithInventoriesUseCase();
    final saveFakeNewItem = MockSaveNewItemOrInventoryUseCase();
    final saveFakeToDeleteItem = MockSaveToDeleteItemOrInventoryUseCase();
    final useCases = ItemUseCases(
      getItemsWithInventoriesUseCase: fakeGetItems,
      getNewItemOrInventoryUseCase: fakeGetNewItem,
      getToDeleteItemOrInventoryUseCase: fakeGetToDeleteItem,
      saveItemsWithInventoriesUseCase: saveFakeItems,
      saveNewItemOrInventoryUseCase: saveFakeNewItem,
      saveToDeleteItemOrInventoryUseCase: saveFakeToDeleteItem,
    );
    final viewModel = AdventureViewModel(useCases);
    final items = DefaultItem.firstItemsAndInventories;
    final inventory = DefaultItem.inventory;

    when(fakeGetItems())
        .thenAnswer((_) async => Result<List<Item>>.success(items));
    when(fakeGetNewItem()).thenAnswer((_) async => Result<Item>.success(inventory));
    when(fakeGetToDeleteItem())
        .thenAnswer((_) async => Result<Item>.success(inventory));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => viewModel)],
        child: MaterialApp(
          title: 'Kotori widget test',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          navigatorObservers: [ModalRouteObserver.observer],
          home: const AdventureScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('아이템, 인벤토리 잘 빌드되었는지 확인', (WidgetTester tester) async {
    await _pumpTestWidget(tester);

    expect(find.byType(DraggableItem), findsNWidgets(3));
    expect(find.byType(DragTargetInventory), findsNWidgets(11));
  });

  testWidgets('아이템 간 이동 및 삭제 되는지 확인', (WidgetTester tester) async {
    final dateEpochValue =
        DefaultItem.item.date.millisecondsSinceEpoch.toString();
    await _pumpTestWidget(tester);

    expect(find.descendant(of: find.byKey(KeyAndString.toDeleteItemOrInventory), matching: find.byKey(Key(dateEpochValue))), findsNothing);
    expect(find.byType(DraggableItem), findsNWidgets(3));

    final itemLocation = tester.getTopLeft(find.byKey(Key(dateEpochValue)));
    final toDeleteLocation = tester.getTopLeft(find.byKey(KeyAndString.toDeleteItemOrInventory));
    final gesture = await tester.startGesture(itemLocation, pointer: 7);
    await tester.pump();

    await gesture.moveTo(toDeleteLocation);
    await tester.pump();

    await gesture.up();
    await tester.pump();

    expect(find.descendant(of: find.byKey(KeyAndString.toDeleteItemOrInventory), matching: find.byKey(Key(dateEpochValue))), findsOneWidget);
    expect(find.byType(GestureDetector), findsOneWidget);

    await tester.tap(find.byKey(KeyAndString.progressButton));
    await tester.pump();

    expect(find.byType(DraggableItem), findsNWidgets(2));
  });

  // 3. 아이템 탭 되는지 확인 (추후)

  // 4. 네비게이션 되는지 확인 (추후)
}
