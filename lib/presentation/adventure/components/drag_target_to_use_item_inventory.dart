import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/util/key_and_string.dart';
import 'package:provider/provider.dart';

class DragTargetToUseItemInventory extends StatelessWidget {
  final int? position;
  final ItemAndInventoryTypes type;
  final BuildContext context;

  const DragTargetToUseItemInventory({
    Key? key,
    required this.context,
    this.position,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AdventureViewModel>();
    return DragTarget(
      key: KeyAndString.toUseItemKey,
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return _buildEmptyInventory();
      },
      onAccept: (data) {
        setOnAccept(data as Map<String, dynamic>, viewModel);
      },
    );
  }

  Widget _buildEmptyInventory() {
    return Container(
      width: 140,
      height: 130,
      decoration: BoxDecoration(
        border: Border.all(
          width: 5,
          color: Colors.black,
        ),
      ),
    );
  }

  void setOnAccept(Map<String, dynamic> data, AdventureViewModel viewModel) {
    final itemRole = data['type'];
    final inventoryRole = type;
    if (itemRole == ItemAndInventoryTypes.itemsWithInventories &&
        inventoryRole == ItemAndInventoryTypes.toUseItem) {
      // items to toUseItem
      viewModel.itemsToUseItem(
          data[KeyAndString.position], data[KeyAndString.item]);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 1500),
          margin: EdgeInsets.only(bottom: 260),
          content: Text(KeyAndString.mainPageToUseItemUsedText)));
    }
  }
}
