import 'package:hive/hive.dart';

part 'diary_entity.g.dart';

@HiveType(typeId: 0)
class DiaryEntity extends HiveObject {
  @HiveField(0)
  int emotion;

  @HiveField(1)
  String picture;

  @HiveField(2)
  String desc;

  @HiveField(3)
  DateTime date;

  DiaryEntity({
    required this.emotion,
    required this.picture,
    required this.desc,
    required this.date,
  });
}
