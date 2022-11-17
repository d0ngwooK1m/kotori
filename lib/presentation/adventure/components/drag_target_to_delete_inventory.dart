import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/adventure/components/draggable_to_delete_item.dart';
import 'package:kotori/util/key_and_string.dart';
import 'package:provider/provider.dart';

class DragTargetToDeleteInventory extends StatelessWidget {
  final ItemAndInventoryTypes type;

  const DragTargetToDeleteInventory({
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
        return (state.deleteItem != null && !state.deleteItem!.isInventory)
            ? DraggableToDeleteItem(
          size: 60,
          type: type,
        )
            : _buildEmptyInventory();
      },
      onAccept: (data) {
        setOnAccept(data as Map<String, dynamic>, context);
      },
    );
  }

  Widget _buildEmptyInventory() {
    return Opacity(
      opacity: 0.1,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            width: 5,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void setOnAccept(Map<String, dynamic> data, BuildContext context) {
    final viewModel = context.read<AdventureViewModel>();
    final itemRole = data['type'];
    final inventoryRole = type;
    if (itemRole == ItemAndInventoryTypes.itemsWithInventories &&
        inventoryRole == ItemAndInventoryTypes.toDeleteItem) {
      // items to delete
      viewModel.itemsToDeleteItem(
          item: data[KeyAndString.item],
          prevPosition: data[KeyAndString.position]);
      viewModel.checkIsOkayToDelete();
    }else if (itemRole == ItemAndInventoryTypes.newItem &&
        inventoryRole == ItemAndInventoryTypes.toDeleteItem) {
      // new to delete
      viewModel.newItemToDeleteItem(viewModel.state.newItem!);
      viewModel.checkIsOkayToDelete();
    }
  }
}
