import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/use_case/diary/daily_diary/daily_diary_use_cases.dart';
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
  group('daily diary view model test', () {
    final getDiaryUseCase = MockGetDiaryUseCase();
    final saveDiaryUseCase = MockSaveDiaryUseCase();
    final useCases = DailyDiaryUseCases(getDiaryUseCase, saveDiaryUseCase);
    final viewModel = DailyDiaryViewModel(useCases);
    final now = Time.now;

    test('오늘의 일기 상태가 잘 불려야한다', () async {
      when(getDiaryUseCase(now: anyNamed('now'))).thenAnswer((_) async => Result.success(Diary(emotion: 3, desc: '', picture: '', date: now)));
      await viewModel.getDiary(now: now);
      expect(viewModel.state.diary!.emotion, 3);
      expect(viewModel.state.message == null, true);
      verify(getDiaryUseCase(now: anyNamed('now')));
    });

    test('오늘의 일기 상태가 잘 저장되어야한다.', () async {
      when(saveDiaryUseCase(now: anyNamed('now'), editedDiary: anyNamed('editedDiary'))).thenAnswer((_) async => const Result.success(null));
      await viewModel.saveDiary(now: now, editedDiary: Diary(emotion: 4, picture: '', desc: '', date: now));
      expect(viewModel.state.message == null, true);
      verify(saveDiaryUseCase(now: anyNamed('now'), editedDiary: anyNamed('editedDiary')));
    });
  });
}
