import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/domain/use_case/diary/get_diary_use_case.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_diary_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DiaryRepository>()])
void main() {
  test('다이어리를 잘 불러와야한다', () async {
    final repository = MockDiaryRepository();
    final useCase = GetDiaryUseCase(repository);
    final now = Time.now;

    when(repository.getDiary(now: anyNamed('now'))).thenAnswer(
      (_) async => Result.success(
        Diary(
          emotion: 0,
          picture: '',
          desc: '',
          date: now,
        ),
      ),
    );
    final result = await useCase(now: now);
    expect(result, isA<Result<Diary>>());
    verify(repository.getDiary(now: anyNamed('now')));
  });
}
