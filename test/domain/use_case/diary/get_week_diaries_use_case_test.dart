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
    final weekend = Time.getWeekend(now, 0);

    when(repository.getWeekDiaries(now: anyNamed('now'))).thenAnswer((_) async => Result.success({
      0: Diary(emotion: 0, picture: '', desc: '', date: weekend.subtract(const Duration(days: 6))),
      1: Diary(emotion: 0, picture: '', desc: '', date: weekend.subtract(const Duration(days: 5))),
      2: Diary(emotion: 0, picture: '', desc: '', date: weekend.subtract(const Duration(days: 4))),
      3: Diary(emotion: 0, picture: '', desc: '', date: weekend.subtract(const Duration(days: 3))),
      4: Diary(emotion: 0, picture: '', desc: '', date: weekend.subtract(const Duration(days: 2))),
      5: Diary(emotion: 0, picture: '', desc: '', date: weekend.subtract(const Duration(days: 1))),
      6: Diary(emotion: 0, picture: '', desc: '', date: weekend),
    }));
    final result = await useCase();
    expect(result, isA<Result<Map<int, Diary>>>());
    verify(repository.getWeekDiaries(now: anyNamed('now')));
  });
}