import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/util/result.dart';

abstract class EmotionRepository {
  Future<Result<Diary>> getDiary();

  Future<Result<String>> insertDiary(Diary diary);

  Future<Result<String>> editDiary(Diary diary);
}