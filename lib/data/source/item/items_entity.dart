import 'package:hive_flutter/hive_flutter.dart';

part 'items_entity.g.dart';

@HiveType(typeId: 1)
class ItemsEntity extends HiveObject {

  @HiveField(0, defaultValue: '')
  String name;

  @HiveField(1, defaultValue: '')
  String desc;

  @HiveField(2, defaultValue: '')
  String picture;

  @HiveField(3)
  DateTime date;

  @HiveField(4, defaultValue: false)
  bool isInventory;

  ItemsEntity(
    this.name,
    this.desc,
    this.picture,
    this.date,
    this.isInventory,
  );
}
