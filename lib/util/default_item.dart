import 'package:kotori/domain/model/item.dart';
import 'package:kotori/util/id_generator.dart';

import 'time.dart';

class DefaultItem {
  static final item = Item(name: '', desc: '', picture: '', date: Time.now, id: IdGenerator.uuid.v1());
  static final inventory = Item(name: '', desc: '', picture: '', date: Time.now, id: IdGenerator.uuid.v1(), isInventory: true);
}