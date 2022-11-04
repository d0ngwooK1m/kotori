import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/domain/use_case/item/get_items_with_inventories_use_case.dart';
import 'package:kotori/util/default_item.dart';
import 'package:kotori/util/result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_items_with_inventories_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ItemRepository>()])
void main() {
  test('아이템과 인벤토리가 잘 불려와지는지 확인', () async {
    final repository = MockItemRepository();
    final useCase = GetItemsWithInventoriesUseCase(repository);
    final itemsAndInventories = DefaultItem.firstItemsAndInventories;

    when(repository.getItemsWithInventories())
        .thenAnswer((_) async => Result.success(itemsAndInventories));
    final result = await useCase();
    expect(result, isA<Result<List<Item>>>());
    verify(repository.getItemsWithInventories());
  });
}
