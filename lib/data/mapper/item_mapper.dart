import 'package:kotori/data/source/item/items_entity.dart';
import 'package:kotori/data/source/item/new_item_entity.dart';
import 'package:kotori/domain/model/item.dart';

import '../source/item/to_delete_item_entity.dart';

extension ToItemFromItemsEntity on ItemsEntity {
  Item toItem() {
    return Item(
      name: name,
      desc: desc,
      picture: picture,
      date: date,
      isInventory: isInventory,
    );
  }
}

extension ToItemFromNewItemEntity on NewItemEntity {
  Item toItem() {
    return Item(
      name: name,
      desc: desc,
      picture: picture,
      date: date,
      isInventory: isInventory,
    );
  }
}

extension ToItemFromToDeleteItemEntity on ToDeleteItemEntity {
  Item toItem() {
    return Item(
      name: name,
      desc: desc,
      picture: picture,
      date: date,
      isInventory: isInventory,
    );
  }
}

extension ToItemsEntity on Item {
  ItemsEntity toItemsEntity() {
    return ItemsEntity(
      name,
      desc,
      picture,
      date,
      isInventory,
    );
  }
}

extension ToNewItemEntity on Item {
  NewItemEntity toNewItemEntity() {
    return NewItemEntity(
      name,
      desc,
      picture,
      date,
      isInventory,
    );
  }
}

extension DeleteItemEntity on Item {
  ToDeleteItemEntity toDeleteItemEntity() {
    return ToDeleteItemEntity(
      name,
      desc,
      picture,
      date,
      isInventory,
    );
  }
}
