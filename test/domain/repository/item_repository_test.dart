import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/data/mapper/item_mapper.dart';
import 'package:kotori/data/repository/item_repository_impl.dart';
import 'package:kotori/data/source/item/item_dao.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/util/default_item.dart';
import 'package:kotori/util/result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'item_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ItemDao>()])
void main() {
  group('item_repository test', () {
    final dao = MockItemDao();
    final repository = ItemRepositoryImpl(dao);
    final item = DefaultItem.item;
    final newItemEntity = item.toNewItemEntity();
    final toDeleteItemEntity = item.toDeleteItemEntity();
    final itemsAndInventories = DefaultItem.firstItemsAndInventories;
    final itemsAndInventoriesEntity =
        itemsAndInventories.map((e) => e.toItemsEntity()).toList();

    test('아이템이나 인벤토리들이 잘 불려와야 함', () async {
      when(dao.getItemsWithInventories())
          .thenAnswer((_) async => itemsAndInventoriesEntity);
      final result =
          await repository.getItemsWithInventories();
      expect(result, isA<Result<List<Item>>>());
      verify(dao.getItemsWithInventories());
    });

    test('아이템과 인벤토리들이 잘 저장되어야 함', () async {
      when(dao.saveItemsWithInventories(items: anyNamed('items')))
          .thenAnswer((_) async {});
      final result =
          await repository.saveItemsWithInventories(items: itemsAndInventories);
      expect(result, isA<Result<void>>());
      verify(dao.saveItemsWithInventories(items: anyNamed('items')));
    });

    test('새 아이템이나 인벤토리가 잘 불려와야 함', () async {
      when(dao.getNewItemOrInventory()).thenAnswer((_) async => newItemEntity);
      final result =
          await repository.getNewItemOrInventory();
      expect(result, isA<Result<Item>>());
      verify(dao.getNewItemOrInventory());
    });

    test('새 아이템이나 인벤토리가 잘 저장되어야 함', () async {
      when(dao.saveNewItemOrInventory(item: anyNamed('item')))
          .thenAnswer((_) async {});
      final result =
          await repository.saveNewItemOrInventory(item: item);
      expect(result, isA<Result<void>>());
      verify(dao.saveNewItemOrInventory(item: anyNamed('item')));
    });

    test('삭제 아이템이나 인벤토리가 잘 불려와야 함', () async {
      when(dao.getToDeleteItemOrInventory()).thenAnswer((_) async => toDeleteItemEntity);
      final result = await repository.getToDeleteItemOrInventory();
      expect(result, isA<Result<Item>>());
      verify(dao.getToDeleteItemOrInventory());
    });

    test('삭제 아이템이나 인벤토리가 잘 저장되어야 함', () async {
      when(dao.saveToDeleteItemOrInventory(item: anyNamed('item'))).thenAnswer((_) async {});
      final result = await repository.saveToDeleteItemOrInventory(item: item);
      expect(result, isA<Result<void>>());
      verify(dao.saveToDeleteItemOrInventory(item: anyNamed('item')));
    });
  });
}
