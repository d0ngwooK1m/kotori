import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/data/repository/diary_repository_impl.dart';
import 'package:kotori/data/source/diary/diary_entity.dart';
import 'package:kotori/data/source/diary/diary_dao.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'diary_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DiaryDao>()])
void main() {
  test('diary_repository test', () async {
    final dao = MockDiaryDao();
    final repository = DiaryRepositoryImpl(dao);
    final now = Time.now;
    final entity = DiaryEntity(
      emotion: 0,
      picture: '',
      desc: '',
      date: now,
    );

    when(dao.getDiary()).thenAnswer((_) async => entity.toFakeDiaryEntity());

    final getDiaryResult = await repository.getDiary();
    expect(getDiaryResult, isA<Result<Diary>>());
    verify(dao.getDiary());

    when(dao.getWeekDiaries()).thenAnswer((_) async => {
          0: entity.toFakeDiaryEntity(),
          1: entity.toFakeDiaryEntity(day: 1),
          2: entity.toFakeDiaryEntity(day: 2),
          3: entity.toFakeDiaryEntity(day: 3),
          4: entity.toFakeDiaryEntity(day: 4),
          5: entity.toFakeDiaryEntity(day: 5),
          6: entity.toFakeDiaryEntity(day: 6),
        });
    final getDiariesResult = await repository.getWeekDiaries();
    expect(getDiariesResult, isA<Result<Map<int, Diary>>>());
    verify(dao.getWeekDiaries());
  });
}