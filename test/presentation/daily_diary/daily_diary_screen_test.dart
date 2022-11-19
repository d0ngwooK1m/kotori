import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/use_case/adventure_use_cases.dart';
import 'package:kotori/domain/use_case/daily_diary_use_cases.dart';
import 'package:kotori/domain/use_case/diary/get_diary_use_case.dart';
import 'package:kotori/domain/use_case/diary/is_okay_to_make_or_use_item_use_case.dart';
import 'package:kotori/domain/use_case/diary/save_diary_use_case.dart';
import 'package:kotori/domain/use_case/item/get_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/get_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/get_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/save_items_with_inventories_use_case.dart';
import 'package:kotori/domain/use_case/item/save_new_item_or_inventory_use_case.dart';
import 'package:kotori/domain/use_case/item/save_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/daily_diary/daily_diary_screen.dart';
import 'package:kotori/presentation/daily_diary/daily_diary_view_model.dart';
import 'package:kotori/util/key_and_string.dart';
import 'package:kotori/util/modal_route_observer.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'daily_diary_screen_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetDiaryUseCase>(),
  MockSpec<SaveDiaryUseCase>(),
  MockSpec<GetItemsWithInventoriesUseCase>(),
  MockSpec<GetNewItemOrInventoryUseCase>(),
  MockSpec<GetToDeleteItemOrInventoryUseCase>(),
  MockSpec<SaveItemsWithInventoriesUseCase>(),
  MockSpec<SaveNewItemOrInventoryUseCase>(),
  MockSpec<SaveToDeleteItemOrInventoryUseCase>(),
  MockSpec<IsOkayToMakeOrUseItemUseCase>(),
])
void main() {
  Future<void> _pumpTestWidget(WidgetTester tester) async {
    final getDiaryUseCase = MockGetDiaryUseCase();
    final saveDiaryUseCase = MockSaveDiaryUseCase();
    final fakeGetItems = MockGetItemsWithInventoriesUseCase();
    final fakeGetNewItem = MockGetNewItemOrInventoryUseCase();
    final fakeGetToDeleteItem = MockGetToDeleteItemOrInventoryUseCase();
    final saveFakeItems = MockSaveItemsWithInventoriesUseCase();
    final saveFakeNewItem = MockSaveNewItemOrInventoryUseCase();
    final saveFakeToDeleteItem = MockSaveToDeleteItemOrInventoryUseCase();
    final fakeIsOkayToMakeNewItem = MockIsOkayToMakeOrUseItemUseCase();

    final now = Time.now;
    when(getDiaryUseCase()).thenAnswer((_) async =>
        Result.success(Diary(emotion: 0, picture: '', desc: '', date: now)));
    when(saveDiaryUseCase(diary: anyNamed('diary')))
        .thenAnswer((_) async => const Result.success(null));

    final useCases = DailyDiaryUseCases(getDiaryUseCase, saveDiaryUseCase);
    final adventureUseCases = AdventureUseCases(
      fakeGetItems,
      fakeGetNewItem,
      fakeGetToDeleteItem,
      saveFakeItems,
      saveFakeNewItem,
      saveFakeToDeleteItem,
      fakeIsOkayToMakeNewItem,
    );
    final viewModel = DailyDiaryViewModel(useCases);
    final adventureViewModel = AdventureViewModel(adventureUseCases);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => viewModel),
          ChangeNotifierProvider(create: (_) => adventureViewModel),
        ],
        builder: (context, child) {
          return MaterialApp(
            title: 'Kotori widget test',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            navigatorObservers: [ModalRouteObserver.dailyDiaryObserver],
            home: DailyDiaryScreen(),
          );
        },
      ),
    );

    verify(getDiaryUseCase());

    await tester.pump();
  }

  testWidgets('위젯들 구성 되어 있는지 확인', (WidgetTester tester) async {
    await _pumpTestWidget(tester);
    final date = '${Time.now.year}년 ${Time.now.month}월 ${Time.now.day}일';
    final titleFinder = find.text(date + KeyAndString.dailyDiaryScreenTitle);
    // expect(titleFinder, findsOneWidget);
    expect(find.byElementType(TextField), findsOneWidget);
    // expect(find.byKey(KeyAndString.dailyDiaryEmotionsKey), findsOneWidget);
  });

  testWidgets('감정 버튼이 잘 클릭되고 변경되었는지 확인', (WidgetTester tester) async {
    await _pumpTestWidget(tester);
    await tester.tap(find.byKey(const Key('1')));
    await tester.pump();
    expect(
        find.byKey(KeyAndString.dailyDiarySelectedEmotionKey), findsOneWidget);
  });

  testWidgets('텍스트가 잘 입력되는지 확인', (WidgetTester tester) async {
    await _pumpTestWidget(tester);
    await tester.enterText(find.byType(TextField), 'test');
    expect(find.text('test'), findsOneWidget);
  });
}
