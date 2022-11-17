import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

part 'item.g.dart';

@freezed
class Item with _$Item {
  factory Item({
    required String name,
    required String desc,
    @Default('assets/images/question_mark.png') String picture,
    required DateTime date,
    @Default(false) bool isInventory,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

extension ToPastDateItem on Item {
  Item toPastDateItem({int days = 0}) {
    return Item(name: name, desc: desc, picture: picture, date: date.subtract(Duration(days: days)));
  }
}