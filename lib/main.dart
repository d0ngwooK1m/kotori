import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kotori/data/source/diary/diary_entity.dart';
import 'package:kotori/data/source/item/items_entity.dart';
import 'package:kotori/data/source/item/new_item_entity.dart';
import 'package:kotori/data/source/item/to_delete_item_entity.dart';
import 'package:kotori/di/provider_setup.dart';
import 'package:kotori/presentation/adventure/adventure_screen.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/daily_diary/daily_diary_screen.dart';
import 'package:kotori/util/default_item.dart';
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
      navigatorObservers: [
        ModalRouteObserver.adventureObserver,
        ModalRouteObserver.dailyDiaryObserver
      ],
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int index = 0;
  final widgets = const [
    AdventureScreen(),
    Center(
      child: Text('test'),
    ),
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final adventureViewModel = context.read<AdventureViewModel>();
    final adventureState = adventureViewModel.state;

    if (state == AppLifecycleState.resumed) {
      adventureViewModel.checkFirstTime();
    } else if (state == AppLifecycleState.inactive) {
      adventureViewModel.saveEveryItemOrInventory(
        items: adventureState.items,
        newItem: adventureState.newItem!,
        toDeleteItem: adventureState.deleteItem!,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
        currentIndex: index,
        onTap: (int page) {
          setState(
            () {
              index = page;
              if (page == 0) {
                viewModel.getEveryItemOrInventory();
              } else {
                viewModel.saveEveryItemOrInventory(
                  items: state.items,
                  newItem: state.newItem!,
                  toDeleteItem: state.deleteItem!,
                );
              }
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: state.isOkayToDelete || state.isOkayToUse ? Colors.red : Colors.blue,
        onPressed: () {
          if (state.isOkayToDelete || state.isOkayToUse) {
            _showDialog(context, viewModel);
          } else {
            _navigateAndDisplaySelection(context);
          }
        },
        child: state.isOkayToDelete || state.isOkayToUse
            ? const Icon(Icons.forward)
            : const Icon(Icons.edit),
      ),
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const DailyDiaryScreen(),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            content: Text('$result')));
    }
  }

  dynamic _showDialog(BuildContext context, AdventureViewModel viewModel) {
    final state = viewModel.state;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          content: state.isOkayToDelete && !state.isOkayToUse
              ? Text('아이템을 삭제할까요?')
              : Text('아이템을 사용할까요?'),
          actions: [
            TextButton(
              onPressed: () {
                if (!mounted) return;
                if (state.isOkayToDelete && !state.isOkayToUse) {
                  viewModel.saveEveryItemOrInventory(
                      items: state.items,
                      newItem: state.newItem!,
                      toDeleteItem: DefaultItem.inventory);
                  viewModel.completeIsOkayToDelete();
                } else {
                  //TODO: 사용 state에 추가 하고 저장
                }
                Navigator.of(buildContext).pop();
              },
              child: Text('예'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(buildContext).pop();
              },
              child: Text('아니오'),
            ),
          ],
        );
      },
    );
  }
}
