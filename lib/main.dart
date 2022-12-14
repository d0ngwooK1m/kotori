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
import 'package:kotori/presentation/daily_diary/daily_diary_view_model.dart';
import 'package:kotori/presentation/week_diaries/week_diaries_screen.dart';
import 'package:kotori/presentation/week_diaries/week_diaries_view_model.dart';
import 'package:kotori/util/color_schemes.g.dart';
import 'package:kotori/util/default_item.dart';
import 'package:kotori/util/key_and_string.dart';
import 'package:kotori/util/modal_route_observer.dart';
import 'package:kotori/util/time.dart';
import 'package:provider/provider.dart';

import 'presentation/error/error_screen.dart';

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
        fontFamily: 'Galmuri',
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Galmuri',
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      themeMode: ThemeMode.system,
      navigatorObservers: [
        ModalRouteObserver.adventureObserver,
        ModalRouteObserver.dailyDiaryObserver
      ],
      builder: (context, widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return ErrorScreen(errorMessage: errorDetails.toString());
        };
        return widget ?? const ErrorScreen(errorMessage: 'main widget build failed');
      },
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
    WeekDiariesScreen(),
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final adventureViewModel = context.read<AdventureViewModel>();
    final adventureState = adventureViewModel.state;
    final dailDiaryViewModel = context.read<DailyDiaryViewModel>();

    if (state == AppLifecycleState.inactive) {
      adventureViewModel.saveEveryItemOrInventory(
        items: adventureState.items,
        newItem: adventureState.newItem ?? DefaultItem.inventory,
        toDeleteItem: adventureState.deleteItem ?? DefaultItem.inventory,
      );
    } else if (state == AppLifecycleState.resumed) {
      dailDiaryViewModel.getDiary(now: Time.now);
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
    final weekDiariesViewModel = context.read<WeekDiariesViewModel>();
    final weekDiaryMessage = context.watch<WeekDiariesViewModel>().state.message;
    final dailyDiaryMessage = context.watch<DailyDiaryViewModel>().state.message;
    return Consumer<AdventureViewModel>(builder: (_, viewModel, __) {
      final state = viewModel.state;
      return dailyDiaryMessage != null ||
              weekDiaryMessage != null
          ? ErrorScreen(errorMessage: dailyDiaryMessage ?? weekDiaryMessage!)
          : Scaffold(
              body: SafeArea(
                child: widgets.elementAt(index),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.map), label: '??????'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.auto_graph), label: '??????'),
                ],
                currentIndex: index,
                onTap: (int page) async {
                  if (page == 1) {
                    await viewModel.saveEveryItemOrInventory(
                      items: state.items,
                      newItem: state.newItem!,
                      toDeleteItem: state.deleteItem!,
                    );
                    await weekDiariesViewModel.getFirstDateEpoch();
                    await weekDiariesViewModel.getWeekDiaries();
                  } else {
                    await viewModel.getEveryItemOrInventory();
                  }
                  setState(() {
                    index = page;
                  });
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                key: KeyAndString.fabKey,
                backgroundColor: state.isOkayToDelete || state.isOkayToUse
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primaryContainer,
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
    });
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
            duration: const Duration(milliseconds: 1000),
            behavior: SnackBarBehavior.floating,
            content: Text(
              '$result',
              style: const TextStyle(fontFamily: 'Galmuri'),
            )));
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
              ? const Text(KeyAndString.mainPageToDeleteText)
              : const Text(KeyAndString.mainPageToUseItemText),
          actions: [
            TextButton(
              onPressed: () {
                if (state.isOkayToDelete && !state.isOkayToUse) {
                  viewModel.saveEveryItemOrInventory(
                      items: state.items,
                      newItem: state.newItem!,
                      toDeleteItem: DefaultItem.inventory);
                  viewModel.completeIsOkayToDelete();
                } else {
                  viewModel.completeIsOkayToUse();
                }
                if (!mounted) return;
                Navigator.of(buildContext).pop();
              },
              child: const Text(KeyAndString.mainPageYesText),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(buildContext).pop();
              },
              child: const Text(KeyAndString.mainPageNoText),
            ),
          ],
        );
      },
    );
  }
}
