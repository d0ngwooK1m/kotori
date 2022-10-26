import 'package:hive_flutter/hive_flutter.dart';

part 'item_entity.g.dart';

@HiveType(typeId: 1)
class ItemEntity extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String desc;

  @HiveField(2)
  String picture;

  @HiveField(3)
  DateTime date;

  @HiveField(4, defaultValue: false)
  bool isInventory;

  ItemEntity({
    required this.name,
    required this.desc,
    required this.picture,
    required this.date,
    this.isInventory = false,
  });
}

extension ToFakeItemEntity on ItemEntity {
  ItemEntity toFakeItemEntity({int day = 0}) {
    return ItemEntity(
      name: name,
      desc: desc,
      picture: picture,
      date: date.add(Duration(days: day)),
    );
  }
}
