import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/adventure/components/draggable_new_item.dart';

class DragTargetNewInventory extends StatelessWidget {
  final AdventureViewModel viewModel;
  final int? position;
  final ItemAndInventoryTypes type;

  const DragTargetNewInventory({
    Key? key,
    required this.viewModel,
    this.position,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
          ) {
        return !viewModel.state.newItem!.isInventory
            ? DraggableNewItem(
          viewModel: viewModel,
          size: 90,
          position: position,
          type: type,
        )
            : _buildEmptyInventory();
      },
      onAccept: (data) {
        setOnAccept(data as Map<String, dynamic>);
      },
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

  void setOnAccept(Map<String, dynamic> data) {
    final itemRole = data['type'];
    final inventoryRole = type;
    if (itemRole == ItemAndInventoryTypes.newItem &&
        inventoryRole == ItemAndInventoryTypes.itemsWithInventories) {
      //new to items
      viewModel.newItemToItems(viewModel.state.newItem!, position!);
    } else if (itemRole == ItemAndInventoryTypes.newItem &&
        inventoryRole == ItemAndInventoryTypes.toDeleteItem) {
      // new to delete
      viewModel.newItemToDeleteItem(viewModel.state.newItem!);
      viewModel.checkIsOkayToDelete();
    }
  }
}
