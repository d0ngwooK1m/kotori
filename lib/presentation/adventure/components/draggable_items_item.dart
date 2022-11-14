import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/util/key_and_string.dart';
import 'package:provider/provider.dart';

class DraggableItemsItem extends StatelessWidget {
  final double size;
  final int position;
  final ItemAndInventoryTypes type;

  const DraggableItemsItem({
    Key? key,
    required this.size,
    required this.position,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdventureViewModel>();
    final state = viewModel.state;
    return Draggable(
      key: Key(state.items[position].date.millisecondsSinceEpoch.toString()),
      data: {
        KeyAndString.item: state.items[position],
        KeyAndString.position: position,
        KeyAndString.type: type,
      },
      feedback: Material(
        child: Container(
          width: size,
          height: size,
          color: Colors.blue,
          child: Text(viewModel.state.items[position].date.toString().split(' ').first),
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
        child: Text(viewModel.state.items[position].date.toString().split(' ').first),
      ),
    );
  }
}
