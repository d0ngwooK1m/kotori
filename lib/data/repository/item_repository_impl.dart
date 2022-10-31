import 'package:kotori/data/mapper/item_mapper.dart';
import 'package:kotori/data/source/item/item_dao.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/repository/item_repository.dart';
import 'package:kotori/util/result.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemDao _dao;

  ItemRepositoryImpl(this._dao);

  @override
  Future<Result<List<Item>>> getItemsWithInventories() async {
    try {
      final result = await _dao.getItemsWithInventories();
      return Result.success(result.map((e) => e.toItem()).toList());
    } catch (e) {
      return Result.error(Exception('Add item to items failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> saveItemsWithInventories({required List<Item> items}) async {
    try {
      await _dao.saveItemsWithInventories(items: items.map((e) => e.toItemsEntity()).toList());
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception('Delete item from items : ${e.toString()}'));
    }
  }

  @override
  Future<Result<Item>> getNewItemOrInventory() async {
    try {
      final result = await _dao.getNewItemOrInventory();
      return Result.success(result.toItem());
    } catch (e) {
      return Result.error(Exception('Add new item failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> saveNewItemOrInventory({required Item item}) async {
    try {
      await _dao.saveNewItemOrInventory(item: item.toNewItemEntity());
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception('Delete new item failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<Item>> getToDeleteItemOrInventory() async {
    try {
      final result = await _dao.getToDeleteItemOrInventory();
      return Result.success(result.toItem());
    } catch (e) {
      return Result.error(Exception('Add to delete item failed : ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> saveToDeleteItemOrInventory({required Item item}) async {
    try {
      await _dao.saveToDeleteItemOrInventory(item: item.toDeleteItemEntity());
      return const Result.success(null);
    } catch (e) {
      return Result.error(Exception('Delete to delete item failed : ${toString()}'));
    }
  }
}