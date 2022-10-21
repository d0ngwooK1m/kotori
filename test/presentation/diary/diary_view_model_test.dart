import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/repository/diary_repository.dart';
import 'package:kotori/presentation/diary/diary_view_model.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'diary_view_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DiaryRepository>()])
void main() {
  test('diary_view_model test', () async {
    final repository = MockDiaryRepository();
    final viewModel = DiaryViewModel(repository);
    final diary = Diary(
      emotion: 0,
      picture: '',
      desc: '',
      date: Time.now,
    );

    when(repository.getDiary()).thenAnswer((_) async => Result.success(diary));
    await viewModel.getTodayDiary();
    expect(viewModel.state.diary, diary);
    verify(repository.getDiary());

    final firstDiary =
        Diary(emotion: 2, picture: '', desc: 'test0', date: Time.now);
    when(repository.insertDiary(firstDiary)).thenAnswer(
        (_) async => const Result.success('insert diary successfully'));
    await viewModel.insertTodayDiary(firstDiary);
    expect(viewModel.state.message, 'insert diary successfully');
    expect(viewModel.state.diary!.emotion, 2);
    expect(viewModel.state.diary!.desc, 'test0');
    verify(repository.insertDiary(firstDiary));

    final editedDiary =
        Diary(emotion: 3, picture: '', desc: 'test1', date: Time.now);
    when(repository.editDiary(editedDiary)).thenAnswer(
        (_) async => const Result.success('edit diary successfully'));
    await viewModel.editTodayDiary(editedDiary);
    expect(viewModel.state.message, 'edit diary successfully');
    expect(viewModel.state.diary!.emotion, 3);
    expect(viewModel.state.diary!.desc, 'test1');
    verify(repository.editDiary(editedDiary));
  });
}
