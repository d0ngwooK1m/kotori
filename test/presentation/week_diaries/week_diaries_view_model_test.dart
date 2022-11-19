import 'package:flutter_test/flutter_test.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/domain/use_case/diary/get_week_diaries_use_case.dart';
import 'package:kotori/presentation/week_diaries/week_diaries_view_model.dart';
import 'package:kotori/util/result.dart';
import 'package:kotori/util/time.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'week_diaries_view_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetWeekDiariesUseCase>()])
void main() {
  group('get week diary view model', () {
    final fakeWeekDiaries = MockGetWeekDiariesUseCase();

    when(fakeWeekDiaries()).thenAnswer((_) async => Result.success(
        List.generate(
            7,
            (index) => Diary(
                emotion: -1,
                picture: '',
                desc: '',
                date: Time.getWeek(Time.now, 0).elementAt(index)))));

    final viewModel = WeekDiariesViewModel(fakeWeekDiaries);

    test('일주일치 일기가 잘 불려야한다', () async {
      await viewModel.getWeekDiaries();
      expect(
          viewModel.state.weekDiaries.map((diary) => diary!.date).toList(),
          List.generate(
              7, (index) => Time.getWeek(Time.now, 0).elementAt(index)));
      verify(fakeWeekDiaries());
    });
  });
}
