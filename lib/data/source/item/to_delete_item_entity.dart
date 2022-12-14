import 'package:hive_flutter/hive_flutter.dart';

part 'to_delete_item_entity.g.dart';

@HiveType(typeId: 3)
class ToDeleteItemEntity extends HiveObject {

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

  ToDeleteItemEntity(
      this.name,
      this.desc,
      this.picture,
      this.date,
      this.isInventory,
      );
}