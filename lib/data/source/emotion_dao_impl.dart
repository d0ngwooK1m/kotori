import 'package:hive/hive.dart';
import 'package:kotori/data/source/diary_entity.dart';
import 'package:kotori/data/source/emotion_dao.dart';
import 'package:kotori/util/time.dart';

class EmotionDaoImpl implements EmotionDao {
  @override
  final Box<DiaryEntity> box;
  final now = Time.now;

  EmotionDaoImpl(this.box);

  // 일기 읽어오기
  @override
  Future<DiaryEntity> getDiary() async {
    final diary = box.values.last;

    return now.isAtSameMomentAs(diary.date)
        ? diary
        : DiaryEntity(
      emotion: 0,
      picture: '',
      desc: '',
      date: now,
    );
  }

  // 일기 추가
  @override
  Future<void> insertDiary(DiaryEntity diary) async {
    await box.add(diary);
  }

  // 일기 수정
  @override
  Future<void> editDiary(DiaryEntity editedDiary) async {
    final diary = await getDiary();
    diary.emotion = editedDiary.emotion;
    diary.picture = editedDiary.picture;
    diary.desc = editedDiary.desc;
    diary.save();
  }

  // 일주일치 일기 불러오기
  @override
  Future<Map<int, DiaryEntity>> getWeekDiaries({int week = 0}) async {
    // 오늘 날짜, 앱 최초 설치한 날짜 필요
    // 첫 그래프 값은 오늘 날짜가 있는 주의 월요일 - 일요일 DiaryEntity 값
    // 앞으로 뒤로 버튼 존재
    // 누르면 한주씩 앞 뒤로 이동, 오늘 날짜가 있는 주 이후, 최초 설치 날짜가 있는 주 이전으로는 이동 불가 => 이건 좀 더 고려해볼 것
    final Map<int, DiaryEntity> map = {};
    var weekend = now;
    for (var i = 0; i < 6; i++) {
      final candidate = now.add(Duration(days: i));
      if (candidate.weekday == DateTime.sunday) {
        weekend = candidate.subtract(Duration(days: 7 * week));
      }
    }

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
