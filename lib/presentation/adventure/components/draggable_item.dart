import 'package:flutter/material.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';

class DraggableItem extends StatelessWidget {
  final double size;
  final int? position;
  final Item item;
  final ItemAndInventoryTypes type;

  const DraggableItem(
      {Key? key, required this.size, this.position, required this.item, required this.type,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable(
      key: Key(item.date.millisecondsSinceEpoch.toString()),
      data: {
        'item': item,
        'position': position,
        'type': type,
      },
      feedback: Material(
        child: Container(
          width: size,
          height: size,
          color: Colors.blue,
          child: const Text('test'),
        ),
      ),
      childWhenDragging: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            width: 5,
            color: Colors.red,
          ),
        ),
      ),
      child: Container(
        width: size,
        height: size,
        color: Colors.blue,
        child: const Text('test'),
      ),
    );
  }
}
