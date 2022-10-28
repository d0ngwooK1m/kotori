import 'package:kotori/data/mapper/item_mapper.dart';
import 'package:kotori/data/source/item/item_dao.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/util/result.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemDao _dao;

  ItemRepositoryImpl(this._dao);

  @override
  Future<Result<List<Item>>> addItemToItems({List<Item>? items}) async {
    try {
      final List<Item> result;
      if (items == null) {
        final data = await _dao.addItemToItems(items: null);
        result = data.map((e) => e.toItem()).toList();
      } else {
        final entities = items.map((item) => item.toItemEntity()).toList();
        final data = await _dao.addItemToItems(items: entities);
        result = data.map((e) => e.toItem()).toList();
      }
      return Result.success(result);
    } catch (e) {
      return Result.error(Exception('Add item to items failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Item>>> deleteItemFromItems({required Item item}) async {
    try {
      final result = await _dao.deleteItemFromItems(item: item.toItemEntity());
      return Result.success(result.map((e) => e.toItem()).toList());
    } catch (e) {
      return Result.error(Exception('Delete item from items : ${e.toString()}'));
    }
  }

  @override
  Future<Result<Item>> addNewItem() async {
    try {
      final result = await _dao.addNewItem();
      return Result.success(result.toItem());
    } catch (e) {
      return Result.error(Exception('Add new item failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<Item>> deleteNewItem() async {
    try {
      final result = await _dao.deleteNewItem();
      return Result.success(result.toItem());
    } catch (e) {
      return Result.error(Exception('Delete new item failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<Item>> addToDeleteItem({required Item item}) async {
    try {
      final result = await _dao.addToDeleteItem(item: item.toItemEntity());
      return Result.success(result.toItem());
    } catch (e) {
      return Result.error(Exception('Add to delete item failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<Item>> deleteToDeleteItem() async {
    try {
      final result = await _dao.deleteToDeleteItem();
      return Result.success(result.toItem());
    } catch (e) {
      return Result.error(Exception('Delete to delete item failed : ${toString()}'));
    }
  }
}