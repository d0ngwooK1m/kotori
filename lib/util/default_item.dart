import 'package:kotori/domain/model/item.dart';

import 'time.dart';

class DefaultItem {
  static final item = Item(
      name: '',
      desc: '',
      date: Time.now,
  );
  static final inventory = Item(
      name: '',
      desc: '',
      date: Time.now,
      isInventory: true,
  );
  static final firstItemsAndInventories = List.generate(9, (index) => index < 2 ? item.toPastDateItem(days: index + 1) : inventory);
}
