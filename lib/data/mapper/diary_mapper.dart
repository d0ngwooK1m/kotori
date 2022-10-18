import 'package:kotori/data/source/diary/diary_entity.dart';
import 'package:kotori/domain/model/diary.dart';

extension ToDiary on DiaryEntity {
  Diary toDiary() {
    return Diary(
      emotion: emotion,
      picture: picture,
      desc: desc,
      date: date,
    );
  }
}

extension ToDiaryEntity on Diary {
  DiaryEntity toDiaryEntity() {
    return DiaryEntity(
      emotion: emotion,
      picture: picture,
      desc: desc,
      date: date,
    );
  }
}
