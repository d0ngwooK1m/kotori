import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/adventure/components/draggable_items_item.dart';
import 'package:kotori/util/key_and_string.dart';

class DragTargetItemsInventory extends StatelessWidget {
  final AdventureViewModel viewModel;
  final int? position;
  final ItemAndInventoryTypes type;

  const DragTargetItemsInventory({
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
        return !viewModel.state.items[position!].isInventory
            ? DraggableItemsItem(
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
    } else if (itemRole == ItemAndInventoryTypes.itemsWithInventories &&
        inventoryRole == ItemAndInventoryTypes.itemsWithInventories) {
      // items to items
      viewModel.setItems(data[KeyAndString.item],
          data[KeyAndString.position], position!);
    } else if (itemRole == ItemAndInventoryTypes.itemsWithInventories &&
        inventoryRole == ItemAndInventoryTypes.toDeleteItem) {
      // items to delete
      viewModel.itemsToDeleteItem(
          item: data[KeyAndString.item],
          prevPosition: data[KeyAndString.position]);
      viewModel.checkIsOkayToDelete();
    } else if (itemRole == ItemAndInventoryTypes.toDeleteItem &&
        inventoryRole == ItemAndInventoryTypes.itemsWithInventories) {
      // delete to items
      viewModel.deleteItemToItems(
          positionTo: position!, item: data[KeyAndString.item]);
      viewModel.completeIsOkayToDelete();
    }
  }
}
