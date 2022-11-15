import 'package:hive/hive.dart';
import 'package:kotori/data/source/diary/diary_dao.dart';
import 'package:kotori/data/source/diary/diary_entity.dart';
import 'package:kotori/util/time.dart';

class DiaryDaoImpl implements DiaryDao {
  final Box<DiaryEntity> box;

  DiaryDaoImpl(this.box);

  @override
  Future<DiaryEntity> getDiary({required DateTime now}) async {
    final newDiary = DiaryEntity(
      picture: '',
      desc: '',
      date: now,
    );
    final result = box.get(Time.getDateKey());
    return result ?? newDiary;
  }

  @override
  Future<bool?> isOkayToMakeItem() async {
    final result = box.get(Time.getDateKey());
    if (result != null) {
      if (!result.isSaved || result.emotion == 2) {
        return null;
      } else if (result.isSaved && result.emotion > 2) {
        return true;
      } else if (result.isSaved && result.emotion < 0) {
        return false;
      }
    }
    return null;
  }

  @override
  Future<void> saveDiary({
    required DiaryEntity diary,
  }) async {
    final result = box.get(Time.getDateKey());
    if (result == null) {
      for (var diary in box.values) {
        if (!diary.isSaved) {
          await box.delete(diary.key);
        }
      }
      await box.put(Time.getDateKey(), diary);
    } else if (!result.isSaved) {
      result.isSaved = true;
      result.emotion = diary.emotion;
      result.desc = diary.desc;
      result.picture = diary.picture;
      result.save();
    }
  }

  @override
  Future<List<DiaryEntity>> getWeekDiaries({required DateTime now, int week = 0}) async {
    // 오늘 날짜, 앱 최초 설치한 날짜 필요
    // 첫 그래프 값은 오늘 날짜가 있는 주의 월요일 - 일요일 DiaryEntity 값
    // 앞으로 뒤로 버튼 존재
    // 누르면 한주씩 앞 뒤로 이동, 오늘 날짜가 있는 주 이후, 최초 설치 날짜가 있는 주 이전으로는 이동 불가 => 이건 좀 더 고려해볼 것
    final List<DiaryEntity> result = [];
    final weekList = Time.getWeek(now, week);
    for (var dateTime in weekList) {
      final diary = box.get(dateTime.millisecondsSinceEpoch.toString());
      diary == null ? result.add(DiaryEntity(picture: '', desc: '', date: dateTime)) : result.add(diary);
    }

    return result;
  }
}
