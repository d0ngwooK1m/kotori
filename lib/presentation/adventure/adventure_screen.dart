import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_state.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/adventure/components/drag_target_items_inventory.dart';
import 'package:kotori/presentation/adventure/components/drag_target_new_inventory.dart';
import 'package:kotori/presentation/adventure/components/drag_target_to_delete_inventory.dart';
import 'package:kotori/util/key_and_string.dart';
import 'package:kotori/util/modal_route_observer.dart';
import 'package:provider/provider.dart';

class AdventureScreen extends StatefulWidget {
  const AdventureScreen({Key? key}) : super(key: key);

  @override
  State<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRouteObserver.adventureObserver
        .subscribe(this, ModalRoute.of(context) as ModalRoute<dynamic>);
  }

  @override
  void dispose() {
    ModalRouteObserver.adventureObserver.unsubscribe(this);
    super.dispose();
  }


  @override
  Future<void> didPush() async {
    final viewModel = context.read<AdventureViewModel>();
    await viewModel.checkFirstTime();
    super.didPush();
  }

  @override
  Future<void> didPop() async {
    final viewModel = context.read<AdventureViewModel>();
    final state = viewModel.state;
    await viewModel.saveEveryItemOrInventory(
      items: state.items,
      newItem: state.newItem!,
      toDeleteItem: state.deleteItem!,
    );
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdventureViewModel>();
    final state = viewModel.state;
    return Scaffold(
      body: state.items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        _buildInventory(viewModel, state),
                        const SizedBox(height: 100),
                        _buildAdventureArea(viewModel),
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
          child: DragTargetItemsInventory(
            viewModel: viewModel,
            type: ItemAndInventoryTypes.itemsWithInventories,
            position: i,
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

  Widget _buildAdventureArea(AdventureViewModel viewModel) {
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
              child: DragTargetNewInventory(
                key: KeyAndString.newItemOrInventory,
                viewModel: viewModel,
                type: ItemAndInventoryTypes.newItem,
              ),
            ),
            Container(
              alignment: const FractionalOffset(0.2, 0.8),
              child: DragTargetToDeleteInventory(
                key: KeyAndString.toDeleteItemOrInventory,
                viewModel: viewModel,
                type: ItemAndInventoryTypes.toDeleteItem,
              ),
            )
          ],
        ),
      ),
    );
  }
}
