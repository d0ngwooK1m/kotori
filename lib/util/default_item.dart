import 'package:kotori/domain/model/item.dart';

import 'time.dart';

class DefaultItem {
  static final item = Item(
      name: '',
      desc: '',
      picture: '',
      date: Time.now,
  );
  static final inventory = Item(
      name: '',
      desc: '',
      picture: '',
      date: Time.now,
      isInventory: true,
  );
}
