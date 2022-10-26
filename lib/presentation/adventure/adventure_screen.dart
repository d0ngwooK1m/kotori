import 'package:flutter/material.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/presentation/adventure/adventure_state.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:provider/provider.dart';

class AdventureScreen extends StatelessWidget {
  const AdventureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdventureViewModel>();
    final state = viewModel.state;
    return Scaffold(
      body: state.items.isEmpty ? const Center(child: CircularProgressIndicator()) : SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 100),
              _buildInventory(viewModel, state),
              const SizedBox(height: 100),
              _buildAdventureArea(viewModel, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInventory(AdventureViewModel viewModel, AdventureState state) {
    final List<Widget> slots = [];
    for (var i = 0; i < 9; i++) {
      final top = (i ~/ 3);
      final left = (i % 3);
      slots.add(
        Positioned(
          top: top * 100,
          left: left * 100,
          child: _buildInventoryTarget(
            viewModel: viewModel,
            position: i,
            items: state.items,
          ),
        ),
      );
    }

    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(width: 5),
      ),
      child: Stack(
        children: slots,
      ),
    );
  }

  Widget _buildAdventureArea(
      AdventureViewModel viewModel, AdventureState state) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 5,
          ),
        ),
        child: Stack(
          children: [
            Container(
              alignment: const FractionalOffset(0.8, 0.8),
              child: state.newItem == null
                  ? Container()
                  : _buildItem(size: 90, item: state.newItem!),
            ),
            Container(
              alignment: const FractionalOffset(0.2, 0.8),
              child: _buildToDeleteTarget(
                  viewModel: viewModel, toDeleteItem: null),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem({required double size, int? position, required Item item}) {
    return Draggable(
      data: {
        'item': item,
        'position': position,
      },
      feedback: Container(
        width: size,
        height: size,
        color: Colors.blue,
      ),
      childWhenDragging: Container(
        width: 90,
        height: 90,
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
      ),
    );
  }

  Widget _buildInventoryTarget({
    required AdventureViewModel viewModel,
    required List<Item> items,
    required int position,
  }) {
    final item = items[position];
    return DragTarget(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return !item.isInventory
            ? _buildItem(size: 90, position: position, item: item)
            : Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 5,
                    color: Colors.red,
                  ),
                ),
              );
      },
      onAccept: (data) {
        final itemInfo = data as Map<String, dynamic>;
        viewModel.setItems(itemInfo['item'], itemInfo['position'], position);
      },
    );
  }

  Widget _buildToDeleteTarget({
    required AdventureViewModel viewModel,
    Item? toDeleteItem,
  }) {
    return DragTarget(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return toDeleteItem != null
            ? _buildItem(size: 90, item: toDeleteItem)
            : Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 5,
                    color: Colors.red,
                  ),
                ),
              );
      },
      onAccept: (data) {},
    );
  }
}
