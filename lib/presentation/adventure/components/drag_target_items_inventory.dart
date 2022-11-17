import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/adventure/components/draggable_items_item.dart';
import 'package:kotori/presentation/adventure/components/item_detail_dialog.dart';
import 'package:kotori/util/key_and_string.dart';
import 'package:provider/provider.dart';

class DragTargetItemsInventory extends StatelessWidget {
  final int position;
  final ItemAndInventoryTypes type;

  const DragTargetItemsInventory(
      {Key? key, required this.position, required this.type})
      : super(key: key);

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
        return (state.items.isNotEmpty && !state.items[position].isInventory)
            ? GestureDetector(
                onTap: () {
                  _showItemDialog(context);
                },
                child: DraggableItemsItem(
                  size: 90,
                  position: position,
                  type: type,
                ),
              )
            : _buildEmptyInventory();
      },
      onAccept: (data) {
        setOnAccept(data as Map<String, dynamic>, context);
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
          color: Colors.black,
        ),
      ),
    );
  }

  void setOnAccept(Map<String, dynamic> data, BuildContext context) {
    final viewModel = context.read<AdventureViewModel>();
    final itemRole = data['type'];
    final inventoryRole = type;
    if (itemRole == ItemAndInventoryTypes.newItem &&
        inventoryRole == ItemAndInventoryTypes.itemsWithInventories) {
      //new to items
      viewModel.newItemToItems(viewModel.state.newItem!, position);
    } else if (itemRole == ItemAndInventoryTypes.itemsWithInventories &&
        inventoryRole == ItemAndInventoryTypes.itemsWithInventories) {
      // items to items
      viewModel.setItems(
          data[KeyAndString.item], data[KeyAndString.position], position);
    } else if (itemRole == ItemAndInventoryTypes.toDeleteItem &&
        inventoryRole == ItemAndInventoryTypes.itemsWithInventories) {
      // delete to items
      viewModel.deleteItemToItems(
          positionTo: position, item: data[KeyAndString.item]);
      viewModel.completeIsOkayToDelete();
    }
  }

  void _showItemDialog(BuildContext context) {
    final items = context.read<AdventureViewModel>().state.items;
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return ItemDetailDialog(
          item: items[position],
          position: position,
        );
      },
    );
  }
}
