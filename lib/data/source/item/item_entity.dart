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

  ItemEntity({
    required this.name,
    required this.desc,
    required this.picture,
    required this.date,
  });
}