import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:kotori/data/source/diary_entity.dart';
import 'package:kotori/data/source/emotion_dao.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  test('emotion_dao test', () async {
    final dir = await getApplicationDocumentsDirectory();
    Hive
      ..init(dir.path)
      ..registerAdapter(DiaryEntityAdapter());
    final box = await Hive.openBox<DiaryEntity>('testDiaries.db');
    await box.clear();
    final dao = EmotionDao(box);

    await dao.insertDiary(
      DiaryEntity(
        emotion: 3,
        picture: '',
        desc: '',
        date: DateTime.now(),
      ),
    );

    expect(dao.box.values.length, 1);

    final diary = await dao.getDiary();

    expect(diary.emotion, 3);

    await dao.editDiary(DiaryEntity(
      emotion: 5,
      picture: '',
      desc: '',
      date: DateTime.now(),
    ));

    expect(dao.box.values.first.emotion, 5);

    final editedDiary = await dao.getDiary();

    expect(editedDiary.emotion, 5);

  });
}
