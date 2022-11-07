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
    final now = Time.now;
    final weekend = Time.getWeekend(now, 0);
    final diariesWithoutInput = await dao.getWeekDiaries(now: now, week: 0);
    expect(diariesWithoutInput.values.map((diary) => diary.date).toList(), [
      weekend.subtract(const Duration(days: 6)),
      weekend.subtract(const Duration(days: 5)),
      weekend.subtract(const Duration(days: 4)),
      weekend.subtract(const Duration(days: 3)),
      weekend.subtract(const Duration(days: 2)),
      weekend.subtract(const Duration(days: 1)),
      weekend.subtract(const Duration(days: 0)),
    ]);

    final todayDiary = await dao.getDiary(now: now);
    expect(todayDiary.emotion, 0);
    expect(todayDiary.date, now);
    expect(todayDiary.desc.isEmpty, true);
    expect(todayDiary.picture.isEmpty, true);

    final editedDiary = DiaryEntity(emotion: 3, picture: '', desc: 'edited daily_diary', date: now);
    await dao.saveDiary(now: now, editedDiary: editedDiary);

    final editedDiaryResult = await dao.getDiary(now: now);
    expect(editedDiaryResult.emotion, 3);
    expect(editedDiaryResult.date, now);
    expect(editedDiaryResult.desc.isEmpty, false);
    expect(editedDiaryResult.picture.isEmpty, true);

    final diaries = await dao.getWeekDiaries(now: now, week: 0);
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
