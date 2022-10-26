import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kotori/data/source/diary/diary_entity.dart';
import 'package:kotori/data/source/item/item_entity.dart';
import 'package:kotori/di/provider_setup.dart';
import 'package:kotori/presentation/adventure/adventure_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ItemEntityAdapter());
  Hive.registerAdapter(DiaryEntityAdapter());
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdventureScreen(),
    );
  }
}
