import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/domain/use_case/item/save_items_with_inventories_use_case.dart';
import 'package:kotori/util/default_item.dart';
import 'package:kotori/util/result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_items_with_inventories_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ItemRepository>()])
void main() {
  test('아이템들이나 인벤토리들이 잘 저장되어야 한다', () async {
    final repository = MockItemRepository();
    final useCase = SaveItemsWithInventoriesUseCase(repository);
    final itemsAndInventories = DefaultItem.firstItemsAndInventories;

    when(repository.saveItemsWithInventories(items: anyNamed('items')))
        .thenAnswer((_) async => const Result.success(null));
    final result = await useCase(items: itemsAndInventories);
    expect(result, isA<Result<void>>());
    verify(repository.saveItemsWithInventories(items: anyNamed('items')));
  });
}