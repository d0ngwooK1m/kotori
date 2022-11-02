import 'package:flutter/material.dart';
import 'package:kotori/domain/util/item_and_inventory_types.dart';
import 'package:kotori/presentation/adventure/adventure_state.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/adventure/components/drag_target_inventory.dart';
import 'package:kotori/util/modal_route_observer.dart';
import 'package:provider/provider.dart';

class AdventureScreen extends StatefulWidget {
  const AdventureScreen({Key? key}) : super(key: key);

  @override
  State<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen>
    with RouteAware, WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    super.didChangeAppLifecycleState(lifecycleState);
    final viewModel = context.read<AdventureViewModel>();
    final state = viewModel.state;
    if (lifecycleState == AppLifecycleState.resumed) {
      viewModel.checkFirstTime();
    } else if (lifecycleState == AppLifecycleState.inactive) {
      viewModel.saveEveryItemOrInventory(
          items: state.items,
          newItem: state.newItem,
          toDeleteItem: state.deleteItem);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRouteObserver.observer
        .subscribe(this, ModalRoute.of(context) as ModalRoute<dynamic>);
  }

  @override
  void dispose() {
    ModalRouteObserver.observer.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didPush() {
    final viewModel = context.read<AdventureViewModel>();
    viewModel.checkFirstTime();
    super.didPush();
  }

  @override
  void didPopNext() {
    final viewModel = context.read<AdventureViewModel>();
    final state = viewModel.state;
    viewModel.saveEveryItemOrInventory(
        items: state.items,
        newItem: state.newItem,
        toDeleteItem: state.deleteItem);
    super.didPopNext();
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
          child: DragTargetInventory(
            viewModel: viewModel,
            type: ItemAndInventoryTypes.itemsWithInventories,
            item: state.items[i],
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
              child: state.isOkayToProcess
                  ? GestureDetector(
                      key: const Key('progressButton'),
                      onTap: () {
                        viewModel.completeProcess();
                      },
                      child: const Icon(Icons.forward, size: 60),
                    )
                  : DragTargetInventory(
                      key: const Key('newItemOrInventory'),
                      viewModel: viewModel,
                      type: ItemAndInventoryTypes.newItem,
                      item: state.newItem,
                    ),
            ),
            Container(
              alignment: const FractionalOffset(0.2, 0.8),
              child: DragTargetInventory(
                key: const Key('toDeleteItemOrInventory'),
                viewModel: viewModel,
                type: ItemAndInventoryTypes.toDeleteItem,
                item: state.deleteItem,
              ),
            )
          ],
        ),
      ),
    );
  }
}
