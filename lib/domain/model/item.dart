import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

part 'item.g.dart';

@freezed
class Item with _$Item {
  factory Item({
    required String name,
    required String desc,
    required String picture,
    required DateTime date,
    @Default(false) bool isInventory,
    required String id,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}