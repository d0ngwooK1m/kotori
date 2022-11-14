import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/adventure/components/drag_target_items_inventory.dart';
import 'package:kotori/presentation/adventure/components/drag_target_new_inventory.dart';
import 'package:kotori/presentation/adventure/components/drag_target_to_delete_inventory.dart';
import 'package:kotori/presentation/adventure/components/drag_target_to_use_item_inventory.dart';
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
    return Scaffold(
      body: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    _buildInventory(),
                    const SizedBox(height: 100),
                    _buildAdventureArea(viewModel),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInventory() {
    final List<Widget> slots = [];
    for (var i = 0; i < 9; i++) {
      final top = (i ~/ 3);
      final left = (i % 3);
      slots.add(
        Positioned(
          top: top * 100,
          left: left * 100,
          child: DragTargetItemsInventory(
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
    final state = viewModel.state;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 5,
          ),
        ),
        child: Stack(
          children: !state.isOkayToUse
              ? _buildNormalInventories()
              : _buildToUseInventory(context),
        ),
      ),
    );
  }

  List<Widget> _buildNormalInventories() {
    return [
      Container(
        alignment: const FractionalOffset(0.8, 0.8),
        child: const DragTargetNewInventory(
          key: KeyAndString.newItemOrInventory,
          type: ItemAndInventoryTypes.newItem,
        ),
      ),
      Container(
        alignment: const FractionalOffset(0.2, 0.8),
        child: const DragTargetToDeleteInventory(
          key: KeyAndString.toDeleteItemOrInventory,
          type: ItemAndInventoryTypes.toDeleteItem,
        ),
      ),
    ];
  }

  List<Widget> _buildToUseInventory(BuildContext context) {
    return [
      Container(
        alignment: const FractionalOffset(0.5, 0.8),
        child: DragTargetToUseItemInventory(
          context: context,
          type: ItemAndInventoryTypes.toUseItem,
        ),
      ),
    ];
  }
}
