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
    final week = Time.getWeek(now, 0);
    final diariesWithoutInput = await dao.getWeekDiaries(now: now, week: 0);
    expect(diariesWithoutInput.map((entity) => entity.date).toList(), week);

    final todayDiary = await dao.getDiary(now: now);
    expect(todayDiary.emotion, -1);
    expect(todayDiary.date, now);
    expect(todayDiary.desc.isEmpty, true);
    expect(todayDiary.picture.isEmpty, true);

    final tempDiary = DiaryEntity(emotion: 3, picture: '', desc: 'edited daily_diary', date: now);
    await dao.saveDiary(diary: tempDiary);
    expect(box.values.length, 1);
    final editedDiary = DiaryEntity(emotion: 3, picture: '', desc: '', date: now, isSaved: true);
    await dao.saveDiary(diary: editedDiary);
    expect(box.values.length, 1);


    final editedDiaryResult = await dao.getDiary(now: now);
    expect(editedDiaryResult.emotion, 3);
    expect(editedDiaryResult.date, now);
    expect(editedDiaryResult.desc.isEmpty, true);
    expect(editedDiaryResult.picture.isEmpty, true);
  });
}
