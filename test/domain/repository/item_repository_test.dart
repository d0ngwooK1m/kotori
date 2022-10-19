import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/data/repository/item_repository_impl.dart';
import 'package:kotori/data/source/item/item_dao.dart';
import 'package:kotori/data/source/item/item_entity.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'item_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ItemDao>()])
void main() {
  test('item_repository test', () async {
    final dao = MockItemDao();
    final repository = ItemRepositoryImpl(dao);
    final now = Time.now;
    final item = ItemEntity(
      name: '',
      desc: '',
      picture: '',
      date: now,
    );

    when(dao.getNewItem()).thenAnswer((_) async => item.toFakeItemEntity());
    final getNewItemResult = await repository.getNewItem();
    expect(getNewItemResult, isA<Result<Item>>());
    verify(dao.getNewItem());

    when(dao.getAllItems()).thenAnswer((_) async => [
      item.toFakeItemEntity(),
      item.toFakeItemEntity(day: 1),
      item.toFakeItemEntity(day: 2),
      item.toFakeItemEntity(day: 3),
      item.toFakeItemEntity(day: 4),
      item.toFakeItemEntity(day: 5),
      item.toFakeItemEntity(day: 6),
      item.toFakeItemEntity(day: 7),
      item.toFakeItemEntity(day: 8),
    ]);
    final getItemsResult = await repository.getAllItems();
    expect(getItemsResult, isA<Result<List<Item>>>());
    verify(dao.getAllItems());
  });
}