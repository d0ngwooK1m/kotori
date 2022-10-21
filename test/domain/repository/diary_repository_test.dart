import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/data/mapper/diary_mapper.dart';
import 'package:kotori/data/repository/diary_repository_impl.dart';
import 'package:kotori/data/source/diary/diary_dao.dart';
import 'package:kotori/data/source/diary/diary_entity.dart';
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
    final weekend = Time.getWeekend(Time.now, 0);
    final entity = DiaryEntity(
      emotion: 0,
      picture: '',
      desc: '',
      date: weekend,
    );

    when(dao.getDiary(now: argThat(isNotNull, named: 'now')))
        .thenAnswer((_) async => entity.toFakeDiaryEntity());
    final getDiaryResult = await repository.getDiary();
    expect(getDiaryResult, isA<Result<Diary>>());
    verify(dao.getDiary(now: argThat(isNotNull, named: 'now')));

    when(dao.getWeekDiaries(
            now: argThat(isNotNull, named: 'now'),
            week: argThat(isNotNull, named: 'week')))
        .thenAnswer((_) async => {
              0: entity.toFakeDiaryEntity(day: 6),
              1: entity.toFakeDiaryEntity(day: 5),
              2: entity.toFakeDiaryEntity(day: 4),
              3: entity.toFakeDiaryEntity(day: 3),
              4: entity.toFakeDiaryEntity(day: 2),
              5: entity.toFakeDiaryEntity(day: 1),
              6: entity.toFakeDiaryEntity(day: 0),
            });
    final getDiariesResult = await repository.getWeekDiaries();
    expect(getDiariesResult, isA<Result<Map<int, Diary>>>());
    verify(dao.getWeekDiaries(
        now: argThat(isNotNull, named: 'now'),
        week: argThat(isNotNull, named: 'week')));

    when(dao.insertDiary(diary: argThat(isNotNull, named: 'diary'))).thenAnswer(
        (_) async => const Result.success('Insert diary successfully'));
    final insertDiaryResult = await repository.insertDiary(entity.toDiary());
    expect(insertDiaryResult, isA<Result<String>>());
    verify(dao.insertDiary(diary: argThat(isNotNull, named: 'diary')));

    when(dao.editDiary(
            now: argThat(isNotNull, named: 'now'),
            editedDiary: argThat(isNotNull, named: 'editedDiary')))
        .thenAnswer(
            (_) async => const Result.success('Edit diary successfully'));
    final editDiaryResult = await repository.editDiary(entity.toDiary());
    expect(editDiaryResult, isA<Result<String>>());
    verify(dao.editDiary(
        now: argThat(isNotNull, named: 'now'),
        editedDiary: argThat(isNotNull, named: 'editedDiary')));
  });
}
