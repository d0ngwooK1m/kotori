import 'package:kotori/data/mapper/item_mapper.dart';
import 'package:kotori/data/source/item/item_dao.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/util/result.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemDao _dao;

  ItemRepositoryImpl(this._dao);

  @override
  Future<Result<String>> deleteItem(Item item) async {
    try {
      await _dao.deleteItem(item.toItemEntity());
      return const Result.success('Delete item successfully');
    } catch (e) {
      return Result.error(Exception('Delete item failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Item>>> getAllItems() async {
    try {
      final entities = await _dao.getAllItems();
      final items = entities.map((entity) => entity.toItem()).toList();
      return Result.success(items);
    } catch (e) {
      return Result.error(Exception('Get all items failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<Item>> getNewItem() async {
    try {
      final entity = await _dao.getNewItem();
      return Result.success(entity.toItem());
    } catch (e) {
      return Result.error(Exception('Get new item failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Item>>> updateAllItems(List<Item> items) async {
    try {
      final entities = items.map((item) => item.toItemEntity()).toList();
      final result = await _dao.updateAllItems(entities);
      final updatedItems = result.map((entity) => entity.toItem()).toList();
      return Result.success(updatedItems);
    } catch (e) {
      return Result.error(Exception('Update all items failed : ${e.toString()}'));
    }
  }

}