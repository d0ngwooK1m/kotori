import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/use_case/daily_diary_use_cases.dart';
import 'package:kotori/domain/use_case/diary/get_diary_use_case.dart';
import 'package:kotori/domain/use_case/diary/save_diary_use_case.dart';
import 'package:kotori/presentation/daily_diary/daily_diary_view_model.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'daily_diary_view_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetDiaryUseCase>(), MockSpec<SaveDiaryUseCase>()])
void main() {
  group('daily diary view model', () {
    final now = Time.now;
    final fakeGetDiary = MockGetDiaryUseCase();
    final fakeSaveDiary = MockSaveDiaryUseCase();

    when(fakeGetDiary()).thenAnswer((_) async =>
        Result.success(
            Diary(emotion: 0, picture: '', desc: '', date: now)));
    when(fakeSaveDiary(diary: anyNamed('diary')))
        .thenAnswer((_) async => const Result.success(null));

    final useCases = DailyDiaryUseCases(fakeGetDiary, fakeSaveDiary);
    final viewModel = DailyDiaryViewModel(useCases);

    test('일기가 잘 불려야한다', () async {
      await viewModel.getDiary(now: now);
      expect(viewModel.state.diary, isNotNull);
      verify(fakeGetDiary());
    });

    test('일기가 잘 저장되어야한다', () async {

      final useCases = DailyDiaryUseCases(fakeGetDiary, fakeSaveDiary);
      final viewModel = DailyDiaryViewModel(useCases);
      await viewModel.saveDiary(
          diary: Diary(emotion: 3, picture: '', desc: '', date: now));
      expect(viewModel.state.message, isNull);
      verify(fakeSaveDiary(diary: anyNamed('diary')));
    });
  });
}
