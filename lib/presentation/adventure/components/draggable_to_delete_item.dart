import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/util/key_and_string.dart';
import 'package:kotori/util/time.dart';
import 'package:provider/provider.dart';

class DraggableToDeleteItem extends StatelessWidget {
  final double size;
  final int? position;
  final ItemAndInventoryTypes type;

  const DraggableToDeleteItem(
      {Key? key, required this.size, this.position, required this.type,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdventureViewModel>();
    final state = viewModel.state;
    return Draggable(
      key: Key(state.deleteItem?.date.millisecondsSinceEpoch.toString() ?? Time.now.toString()),
      data: {
        KeyAndString.item : state.deleteItem,
        KeyAndString.position : position,
        KeyAndString.type : type,
      },
      feedback: SizedBox(
        width: size,
        height: size,
        child: Image.asset(viewModel.state.deleteItem?.picture ?? 'assets/images/question_mark.png'),
      ),
      childWhenDragging: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            width: 5,
            color: Colors.black,
          ),
        ),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            width: 5,
            color: Colors.black,
          ),
        ),
        child: Image.asset(viewModel.state.deleteItem?.picture ?? 'assets/images/question_mark.png'),
      ),
    );
  }
}
