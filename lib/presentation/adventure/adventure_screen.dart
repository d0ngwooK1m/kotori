import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/adventure/components/drag_target_items_inventory.dart';
import 'package:kotori/presentation/adventure/components/drag_target_new_inventory.dart';
import 'package:kotori/presentation/adventure/components/drag_target_to_delete_inventory.dart';
import 'package:kotori/presentation/adventure/components/drag_target_to_use_item_inventory.dart';
import 'package:kotori/util/default_item.dart';
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

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        children: slots,
      ),
    );
  }

  Widget _buildAdventureArea(AdventureViewModel viewModel) {
    final state = viewModel.state;
    return Container(
      width: 400,
      height: 280,
      decoration: BoxDecoration(
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/back_ground_with_ground.png'),
        ),
        border: Border.all(
          width: 5,
        ),
      ),
      child: Stack(
        children: !state.isOkayToUse
            ? _buildNormalInventories()
            : _buildToUseInventory(),
      ),
    );
  }

  List<Widget> _buildNormalInventories() {
    final state = context.watch<AdventureViewModel>().state;
    final newItem = state.newItem ?? DefaultItem.inventory;
    return [
      Container(
        alignment: const FractionalOffset(0.9, 0),
        child: Image.asset(newItem.isInventory
            ? 'assets/images/kotori_move.png'
            : 'assets/images/kotori_stop.png'),
      ),
      Container(
        alignment: const FractionalOffset(0.845, 0.16),
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.red)),
              child: Center(
                  child: Text(newItem.isInventory ? '좋은일은\n언제나\n있을거야' : '!'))),
        ),
      ),
      Container(
        alignment: const FractionalOffset(0.95, 0.85),
        child: const DragTargetNewInventory(
          key: KeyAndString.newItemOrInventory,
          type: ItemAndInventoryTypes.newItem,
        ),
      ),
      Container(
        alignment: const FractionalOffset(0.05, 0.85),
        child: const DragTargetToDeleteInventory(
          key: KeyAndString.toDeleteItemOrInventory,
          type: ItemAndInventoryTypes.toDeleteItem,
        ),
      ),
    ];
  }

  List<Widget> _buildToUseInventory() {
    return [
      Container(
        alignment: const FractionalOffset(0.9, 0),
        child: Image.asset('assets/images/kotori_sleep.png'),
      ),
      Container(
        decoration: BoxDecoration(border: Border.all(width: 5)),
        alignment: const FractionalOffset(0.5, 0.9),
        child: DragTargetToUseItemInventory(
          context: context,
          type: ItemAndInventoryTypes.toUseItem,
        ),
      ),
      Container(
        alignment: const FractionalOffset(0.845, 0.16),
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.red)),
              child: const Center(child: Text('zzz...'))),
        ),
      ),
    ];
  }
}
