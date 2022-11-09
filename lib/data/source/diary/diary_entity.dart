import 'package:hive/hive.dart';
part 'diary_entity.g.dart';

@HiveType(typeId: 0)
class DiaryEntity extends HiveObject {
  @HiveField(0, defaultValue: -1)
  int emotion;

  @HiveField(1)
  String picture;

  @HiveField(2)
  String desc;

  @HiveField(3)
  DateTime date;

  @HiveField(4, defaultValue: false)
  bool isSaved;

  DiaryEntity({
    this.emotion = -1,
    required this.picture,
    required this.desc,
    required this.date,
    this.isSaved = false,
  });
}

extension ToFakeDiaryEntity on DiaryEntity {
  DiaryEntity toFakeDiaryEntity({int day = 0}) {
    return DiaryEntity(
      emotion: emotion,
      picture: picture,
      desc: desc,
      date: date.subtract(Duration(days: day)),
    );
  }
}
