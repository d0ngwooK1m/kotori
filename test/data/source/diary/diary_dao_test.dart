import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:kotori/data/source/diary/diary_entity.dart';
import 'package:kotori/data/source/diary/diary_dao_impl.dart';
import 'package:kotori/util/time.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  test('diary_dao test', () async {
    final dir = await getApplicationDocumentsDirectory();
    Hive
      ..init(dir.path)
      ..registerAdapter(DiaryEntityAdapter());
    final box = await Hive.openBox<DiaryEntity>('test_diaries.db');
    await box.clear();
    final dao = DiaryDaoImpl(box);
    final weekend = Time.getWeekend(Time.now, 0);

    await dao.insertDiary(
      diary: DiaryEntity(
        emotion: 3,
        picture: '',
        desc: '',
        date: Time.now,
      ),
    );

    expect(dao.box.values.length, 1);

    final diary = await dao.getDiary(now: Time.now);

    expect(diary.emotion, 3);

    await dao.editDiary(now: Time.now, editedDiary: DiaryEntity(
      emotion: 5,
      picture: '',
      desc: '',
      date: Time.now,
    ));

    expect(dao.box.values.first.emotion, 5);

    final editedDiary = await dao.getDiary(now: Time.now);

    expect(editedDiary.emotion, 5);

    final diaries = await dao.getWeekDiaries(now: Time.now, week: 0);

    expect(diaries.values.map((diary) => diary.date).toList(), [
      weekend.subtract(const Duration(days: 6)),
      weekend.subtract(const Duration(days: 5)),
      weekend.subtract(const Duration(days: 4)),
      weekend.subtract(const Duration(days: 3)),
      weekend.subtract(const Duration(days: 2)),
      weekend.subtract(const Duration(days: 1)),
      weekend.subtract(const Duration(days: 0)),
    ]);
  });
}
