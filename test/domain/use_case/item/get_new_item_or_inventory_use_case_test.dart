import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/domain/use_case/item/get_new_item_or_inventory_use_case.dart';
import 'package:kotori/util/default_item.dart';
import 'package:kotori/util/result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_new_item_or_inventory_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ItemRepository>()])
void main() {
  test('새 아이템이나 인벤토리가 잘 불려지는지 확인', () async {
    final repository = MockItemRepository();
    final useCase = GetNewItemOrInventoryUseCase(repository);
    final item = DefaultItem.item;

    when(repository.getNewItemOrInventory())
        .thenAnswer((_) async => Result.success(item));
    final result = await useCase();
    expect(result, isA<Result<Item>>());
    verify(repository.getNewItemOrInventory());
  });
}
