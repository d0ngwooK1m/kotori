import 'package:freezed_annotation/freezed_annotation.dart';

part 'emotion.freezed.dart';

@freezed
class Emotion with _$Emotion {
  const factory Emotion.best(int emotion) = Best;
  const factory Emotion.good(int emotion) = Good;
  const factory Emotion.normal(int emotion) = Normal;
  const factory Emotion.bad(int emotion) = Bad;
  const factory Emotion.worst(int emotion) = Worst;
  const factory Emotion.noRecord(int emotion) = NoRecord;
}