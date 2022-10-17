import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:kotori/data/source/diary_entity.dart';
import 'package:kotori/data/source/emotion_dao_impl.dart';
import 'package:kotori/util/time.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  test('emotion_dao test', () async {
    final dir = await getApplicationDocumentsDirectory();
    Hive
      ..init(dir.path)
      ..registerAdapter(DiaryEntityAdapter());
    final box = await Hive.openBox<DiaryEntity>('testDiaries.db');
    await box.clear();
    final dao = EmotionDaoImpl(box);
    final now = Time.now;

    await dao.insertDiary(
      DiaryEntity(
        emotion: 3,
        picture: '',
        desc: '',
        date: now,
      ),
    );

    expect(dao.box.values.length, 1);

    final diary = await dao.getDiary();

    expect(diary.emotion, 3);

    await dao.editDiary(DiaryEntity(
      emotion: 5,
      picture: '',
      desc: '',
      date: now,
    ));

    expect(dao.box.values.first.emotion, 5);

    final editedDiary = await dao.getDiary();

    expect(editedDiary.emotion, 5);

    final diaries = await dao.getWeekDiaries();

    expect(diaries.values.map((diary) => diary.date).toList(), [
      now.subtract(const Duration(days: 6)),
      now.subtract(const Duration(days: 5)),
      now.subtract(const Duration(days: 4)),
      now.subtract(const Duration(days: 3)),
      now.subtract(const Duration(days: 2)),
      now.subtract(const Duration(days: 1)),
      now.subtract(const Duration(days: 0)),
    ]);
  });
}
