import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kotori/data/source/diary_entity.dart';

class EmotionDao {
  final Box<DiaryEntity> box;
  final now = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd');

  EmotionDao(this.box);

  // 일기 읽어오기
  Future<DiaryEntity> getDiary() async {
    final diary = box.values.last;

    return formatter.format(diary.date) == formatter.format(now)
        ? diary
        : DiaryEntity(
            emotion: 0,
            picture: '',
            desc: '',
            date: now,
          );
  }

  // 일기 추가
  Future<void> insertDiary(DiaryEntity diary) async {
    await box.add(diary);
  }

  // 일기 수정
  Future<void> editDiary(DiaryEntity editedDiary) async {
    final diary = await getDiary();
    diary.emotion = editedDiary.emotion;
    diary.picture = editedDiary.picture;
    diary.desc = editedDiary.desc;
    diary.date = editedDiary.date;
    diary.save();
  }
}
