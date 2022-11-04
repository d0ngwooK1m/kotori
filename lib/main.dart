import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kotori/data/source/diary/diary_entity.dart';
import 'package:kotori/data/source/item/items_entity.dart';
import 'package:kotori/data/source/item/new_item_entity.dart';
import 'package:kotori/data/source/item/to_delete_item_entity.dart';
import 'package:kotori/di/provider_setup.dart';
import 'package:kotori/presentation/adventure/adventure_screen.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/util/modal_route_observer.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive
    ..registerAdapter(ItemsEntityAdapter())
    ..registerAdapter(NewItemEntityAdapter())
    ..registerAdapter(ToDeleteItemEntityAdapter())
    ..registerAdapter(DiaryEntityAdapter());
  final providers = await getProviders();
  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kotori',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [ModalRouteObserver.observer],
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  final widgets = const [
    AdventureScreen(),
    Center(
      child: Text('test'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdventureViewModel>();
    final state = viewModel.state;
    return Scaffold(
      body: SafeArea(
        child: widgets.elementAt(index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'adventure'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'graph'),
        ],
        onTap: (int page) {
          setState(
            () {
              index = page;
              if (page == 0) {
                viewModel.getEveryItemOrInventory();
              } else {
                viewModel.saveEveryItemOrInventory(
                  items: state.items,
                  newItem: state.newItem,
                  toDeleteItem: state.deleteItem,
                );
              }
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('it\'s a diary button!');
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
