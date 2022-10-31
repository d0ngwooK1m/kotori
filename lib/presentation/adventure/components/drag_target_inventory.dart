import 'package:flutter/material.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/adventure/components/draggable_item.dart';

class DragTargetInventory extends StatelessWidget {
  final AdventureViewModel viewModel;
  final int? position;
  final ItemAndInventoryTypes type;
  final Item item;

  const DragTargetInventory({
    Key? key,
    required this.viewModel,
    this.position,
    required this.type,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return !item.isInventory
            ? DraggableItem(
                size: 90,
                position: position,
                item: item,
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
      viewModel.newItemToItems(item, position!);
      viewModel.checkProcess();
    } else if (itemRole == ItemAndInventoryTypes.itemsWithInventories &&
        inventoryRole == ItemAndInventoryTypes.itemsWithInventories) {
      // items to items
      viewModel.setItems(data['item'], data['position'], position!);
    } else if (itemRole == ItemAndInventoryTypes.itemsWithInventories &&
        inventoryRole == ItemAndInventoryTypes.toDeleteItem) {
      // items to delete
      viewModel.itemsToDeleteItem(item: data['item'], prevPosition: data['position']);
      viewModel.checkProcess();
    } else if (itemRole == ItemAndInventoryTypes.toDeleteItem &&
        inventoryRole == ItemAndInventoryTypes.itemsWithInventories) {
      // delete to items
      viewModel.deleteItemToItems(positionTo: position!, item: data['item']);
    } else if (itemRole == ItemAndInventoryTypes.newItem && inventoryRole == ItemAndInventoryTypes.toDeleteItem) {
      // new to delete
      viewModel.newItemToDeleteItem(item);
      viewModel.checkProcess();
    }
  }
}