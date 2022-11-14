import 'package:flutter/material.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/presentation/week_diaries/components/diary_summary.dart';
import 'package:kotori/presentation/week_diaries/components/emotiton_graph.dart';
import 'package:kotori/presentation/week_diaries/week_diaries_view_model.dart';
import 'package:kotori/util/time.dart';
import 'package:provider/provider.dart';

class WeekDiariesScreen extends StatefulWidget {
  const WeekDiariesScreen({Key? key}) : super(key: key);

  @override
  State<WeekDiariesScreen> createState() => _WeekDiariesScreenState();
}

class _WeekDiariesScreenState extends State<WeekDiariesScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeekDiariesViewModel>(
      builder: (_, viewModel, __) {
        final weekDiaries = viewModel.state.weekDiaries;
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                _buildSelector(viewModel),
                EmotionGraph(weekDiaries: weekDiaries),
                const SizedBox(height: 10),
                _buildDiarySummaries(weekDiaries.values.toList()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelector(WeekDiariesViewModel viewModel) {
    final diaries = viewModel.state.weekDiaries.values;
    final monday = diaries.first?.date.toString().split(' ').first ?? '';
    final sunday = diaries.last?.date.toString().split(' ').first ?? '';
    final latestSunday =
        Time.getWeekend(Time.now, 0).toString().split(' ').first;
    final state = viewModel.state;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            await viewModel.getWeekDiaries(week: state.week + 1);
          },
          child: const Icon(
            Icons.arrow_left,
            size: 36,
          ),
        ),
        Text(
          '$monday ~ $sunday',
          style: const TextStyle(fontSize: 18),
        ),
        latestSunday == sunday
            ? const Padding(
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.arrow_right,
                  size: 36,
                  color: Colors.grey,
                ),
              )
            : GestureDetector(
                onTap: () async {
                  await viewModel.getWeekDiaries(week: state.week - 1);
                },
                child: const Icon(
                  Icons.arrow_right,
                  size: 36,
                ),
              ),
      ],
    );
  }

  Widget _buildDiarySummaries(List<Diary?> diaries) {
    final List<DiarySummary> result = [];
    for (var diary in diaries) {
      if ((diary?.emotion ?? -1) != -1) {
        result.add(DiarySummary(diary: diary!));
      }
    }
    return Expanded(
      child: ListView(
        children: result,
      ),
    );
  }
}
