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
  group('diary_repository test', () {
    final dao = MockDiaryDao();
    final repository = DiaryRepositoryImpl(dao);
    final now = Time.now;
    final week = Time.getWeek(now, 0);

    DiaryEntity getEntity({int pastDays = 0}) {
      return DiaryEntity(
        emotion: 0,
        picture: '',
        desc: '',
        date: week[pastDays],
      );
    }

    test('일기가 잘 불려와야 한다.', () async {
      when(dao.getDiary(now: anyNamed('now')))
          .thenAnswer((_) async => getEntity());
      final getDiaryResult = await repository.getDiary(now: now);
      expect(getDiaryResult, isA<Result<Diary>>());
      verify(dao.getDiary(now: anyNamed('now')));
    });

    test('일기가 잘 저장되어야 한다', () async {
      when(dao.saveDiary(diary: anyNamed('diary')))
          .thenAnswer((_) async => const Result.success(null));
      final result = await repository.saveDiary(diary: getEntity().toDiary());
      expect(result, isA<Result<void>>());
      verify(dao.saveDiary(diary: anyNamed('diary')));
    });

    test('일주일치 일기가 잘 불려야 한다', () async {
      when(dao.getWeekDiaries(now: anyNamed('now'), week: anyNamed('week')))
          .thenAnswer((_) async => List.generate(7, (index) => getEntity(pastDays: index)));
      final getDiariesResult = await repository.getWeekDiaries(now: now);
      expect(getDiariesResult, isA<Result<List<Diary>>>());
      verify(dao.getWeekDiaries(
        now: anyNamed('now'),
        week: anyNamed('week'),
      ));
    });
  });
}
