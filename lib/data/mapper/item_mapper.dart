import 'package:kotori/data/source/item/item_entity.dart';
import 'package:kotori/domain/model/item.dart';

extension ToItem on ItemEntity {
  Item toItem() {
    return Item(
      name: name,
      desc: desc,
      picture: picture,
      date: date,
      isInventory: isInventory,
      id: id,
    );
  }
}

extension ToItemEntity on Item {
  ItemEntity toItemEntity() {
    return ItemEntity(
      name: name,
      desc: desc,
      picture: picture,
      date: date,
      isInventory: isInventory,
      id: id,
    );
  }
}
