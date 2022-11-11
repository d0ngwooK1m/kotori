import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/util/key_and_string.dart';

class DraggableItemsItem extends StatelessWidget {
  final AdventureViewModel viewModel;
  final double size;
  final int? position;
  final ItemAndInventoryTypes type;

  const DraggableItemsItem(
      {Key? key, required this.viewModel, required this.size, this.position, required this.type,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable(
      key: Key(viewModel.newItem.date.millisecondsSinceEpoch.toString()),
      data: {
        KeyAndString.item : viewModel.state.items[position!],
        KeyAndString.position : position,
        KeyAndString.type : type,
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
