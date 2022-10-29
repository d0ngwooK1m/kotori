import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kotori/domain/model/item.dart';

part 'adventure_state.freezed.dart';

part 'adventure_state.g.dart';

@freezed
class AdventureState with _$AdventureState {
  factory AdventureState({
    required Item newItem,
    required Item deleteItem,
    @Default([]) List<Item> items,
    @Default(false) bool isLoading,
    @Default(false) bool isOkayToProcess,
    String? message,
  }) = _AdventureState;

  factory AdventureState.fromJson(Map<String, dynamic> json) => _$AdventureStateFromJson(json);
}