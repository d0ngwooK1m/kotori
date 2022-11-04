import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/domain/use_case/item/save_to_delete_item_or_inventory_use_case.dart';
import 'package:kotori/util/default_item.dart';
import 'package:kotori/util/result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_to_delete_item_or_inventory_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ItemRepository>()])
void main() {
  test('삭제할 아이템이나 인벤토리가 잘 저장되어야한다', () async {
    final repository = MockItemRepository();
    final useCase = SaveToDeleteItemOrInventoryUseCase(repository);
    final item = DefaultItem.item;

    when(repository.saveToDeleteItemOrInventory(item: anyNamed('item')))
        .thenAnswer((_) async => const Result.success(null));
    final result = await useCase(item: item);
    expect(result, isA<Result<void>>());
    verify(repository.saveToDeleteItemOrInventory(item: anyNamed('item')));
  });
}
