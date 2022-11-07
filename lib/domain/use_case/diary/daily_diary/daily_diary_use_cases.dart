import 'package:kotori/domain/use_case/diary/get_diary_use_case.dart';
import 'package:kotori/domain/use_case/diary/save_diary_use_case.dart';

class DailyDiaryUseCases {
  final GetDiaryUseCase getDiaryUseCase;
  final SaveDiaryUseCase saveDiaryUseCase;

  DailyDiaryUseCases(this.getDiaryUseCase, this.saveDiaryUseCase);
}
