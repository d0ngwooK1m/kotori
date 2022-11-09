import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/domain/use_case/diary/save_diary_use_case.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_diary_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DiaryRepository>()])
void main() {
  test('다이어리가 잘 저장되어야한다', () async {
    final repository = MockDiaryRepository();
    final useCase = SaveDiaryUseCase(repository);

    when(repository.saveDiary(diary: anyNamed('diary'))).thenAnswer((_) async => const Result.success(null));
    final result = await useCase(diary: Diary(emotion: 3, desc: '', picture: '', date: Time.now));
    expect(result, isA<Result<void>>());
    verify(repository.saveDiary(diary: anyNamed('diary')));
  });
}