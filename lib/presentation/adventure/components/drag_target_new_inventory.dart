import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/adventure/components/draggable_new_item.dart';
import 'package:provider/provider.dart';

class DragTargetNewInventory extends StatelessWidget {
  final ItemAndInventoryTypes type;

  const DragTargetNewInventory({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdventureViewModel>();
    final state = viewModel.state;
    return DragTarget(
      builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
          ) {
        return (state.newItem != null && !state.newItem!.isInventory)
            ? DraggableNewItem(
          size: 90,
          type: type,
        )
            : _buildEmptyInventory();
      },
      onAccept: (data) {},
    );
  }

  Widget _buildEmptyInventory() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        border: Border.all(
          width: 5,
          color: Colors.red,
        ),
      ),
    );
  }
}
