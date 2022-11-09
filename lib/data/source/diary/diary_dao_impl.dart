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
    if (box.values.isNotEmpty) {
      final diary = box.values.last;
      return now.isAtSameMomentAs(diary.date) ? diary : newDiary;
    } else {
      return newDiary;
    }
  }

  // 일기 저장
  @override
  Future<void> saveDiary({
    required DiaryEntity diary,
  }) async {
    if (box.values.isNotEmpty) {
      final lastDiary = box.values.last;
      if (!lastDiary.date.isAtSameMomentAs(diary.date) && lastDiary.isSaved) {
        await box.add(diary);
      } else {
        await box.deleteAt(box.values.length - 1);
        await box.add(diary);
      }
    } else {
      await box.add(diary);
    }
  }

  @override
  Future<Map<int, DiaryEntity>> getWeekDiaries(
      {required DateTime now, int week = 0}) async {
    // 오늘 날짜, 앱 최초 설치한 날짜 필요
    // 첫 그래프 값은 오늘 날짜가 있는 주의 월요일 - 일요일 DiaryEntity 값
    // 앞으로 뒤로 버튼 존재
    // 누르면 한주씩 앞 뒤로 이동, 오늘 날짜가 있는 주 이후, 최초 설치 날짜가 있는 주 이전으로는 이동 불가 => 이건 좀 더 고려해볼 것
    final Map<int, DiaryEntity> map = {};
    final weekend = Time.getWeekend(now, week);
    for (var element in box.values) {
      final inDays = weekend.difference(element.date).inDays.toInt();
      if (inDays < 7) {
        map.putIfAbsent(6 - inDays, () => element);
      }
    }

    for (var i = 0; i < 7; i++) {
      map.putIfAbsent(
          i,
          () => DiaryEntity(
                emotion: 0,
                picture: '',
                desc: '',
                date: weekend.subtract(Duration(days: 6 - i)),
              ));
    }

    final result = Map.fromEntries(
        map.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));

    return result;
  }
}
