import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/domain/use_case/diary/get_week_diaries_use_case.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_week_diaries_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DiaryRepository>()])
void main() {
  test('일주일 일기가 잘 불려야한다.', () async {
    final repository = MockDiaryRepository();
    final useCase = GetWeekDiariesUseCase(repository);
    final now = Time.now;
    final week = Time.getWeek(now, 0);
    Diary getDiary({int pastDays = 0}) {
      return Diary(
        emotion: 0,
        picture: '',
        desc: '',
        date: week[pastDays],
      );
    }

    when(repository.getWeekDiaries(now: anyNamed('now'))).thenAnswer((_) async => Result.success(List.generate(7, (index) => getDiary(pastDays: index))));
    final result = await useCase();
    expect(result, isA<Result<List<Diary>>>());
    verify(repository.getWeekDiaries(now: anyNamed('now')));
  });
}