import 'package:flutter/material.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/presentation/daily_diary/daily_diary_view_model.dart';
import 'package:kotori/presentation/week_diaries/week_diaries_view_model.dart';
import 'package:kotori/util/key_and_string.dart';
import 'package:kotori/util/modal_route_observer.dart';
import 'package:kotori/util/time.dart';
import 'package:provider/provider.dart';

class DailyDiaryScreen extends StatefulWidget {
  const DailyDiaryScreen({Key? key}) : super(key: key);

  @override
  State<DailyDiaryScreen> createState() => _DailyDiaryScreenState();
}

class _DailyDiaryScreenState extends State<DailyDiaryScreen> with RouteAware {
  final images = [
    'assets/images/kotori_sad_face.png',
    'assets/images/kotori_little_sad_face.png',
    'assets/images/kotori_normal_face.png',
    'assets/images/kotori_little_good_face.png',
    'assets/images/kotori_good_face.png',
  ];

  int selectedColorIdx = -1;
  TextEditingController controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRouteObserver.dailyDiaryObserver
        .subscribe(this, ModalRoute.of(context) as ModalRoute<dynamic>);
  }

  @override
  void dispose() {
    controller.dispose();
    ModalRouteObserver.dailyDiaryObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Future<void> didPush() async {
    final viewModel = context.read<DailyDiaryViewModel>();
    final diaryViewModel = context.watch<DailyDiaryViewModel>();

    await viewModel.getDiary(now: Time.now);
    controller.text = diaryViewModel.state.diary?.desc ?? '';
    setState(() {
      selectedColorIdx = diaryViewModel.state.diary?.emotion ?? -1;
    });
    super.didPush();
  }

  @override
  Future<void> didPop() async {
    final diaryViewModel = context.read<DailyDiaryViewModel>();
    final diaryState = diaryViewModel.state;
    final diary = Diary(
      emotion: selectedColorIdx,
      picture: diaryState.diary?.picture ?? '',
      desc: controller.text,
      date: diaryState.diary?.date ?? Time.now,
    );
    await diaryViewModel.saveDiary(diary: diary);
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DailyDiaryViewModel>(builder: (_, viewModel, __) {
      final state = viewModel.state;
      final adventureViewModel = context.read<AdventureViewModel>();
      final weekDiariesViewModel = context.read<WeekDiariesViewModel>();
      return WillPopScope(
        onWillPop: () async {
          if (!mounted) return false;
          if (state.diary != null) {
            if (!(state.diary!.isSaved) && selectedColorIdx != -1) {
              Navigator.pop(context, KeyAndString.dailyDiaryTempSaved);
            } else {
              Navigator.pop(context);
            }
          }
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Center(
              child: ListView(
                children: [
                  _buildEmotion(diary: state.diary),
                  _buildDesc(diary: state.diary),
                ],
              ),
            ),
          ),
          bottomNavigationBar:
              const SizedBox(height: kBottomNavigationBarHeight),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            key: KeyAndString.dailyDiarySaveButton,
            onPressed: () async {
              await _saveDiary(
                  viewModel, adventureViewModel, weekDiariesViewModel);
            },
            child: const Icon(Icons.save),
          ),
        ),
      );
    });
  }

  Widget _buildEmotion({required Diary? diary}) {
    final date =
        '${diary?.date.year}${KeyAndString.year} ${diary?.date.month}${KeyAndString.month} ${diary?.date.day}${KeyAndString.day}';

    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          (diary == null ? '' : date) + KeyAndString.dailyDiaryScreenTitle,
          style: const TextStyle(fontSize: 36),
        ),
        const SizedBox(height: 20),
        Row(
          key: KeyAndString.dailyDiaryEmotionsKey,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GestureDetector(
                key: index == selectedColorIdx
                    ? KeyAndString.dailyDiarySelectedEmotionKey
                    : Key(index.toString()),
                onTap: () {
                  setState(() {
                    selectedColorIdx = index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(selectedColorIdx == index ? 0 : 5),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // image: DecorationImage(
                    //   fit: BoxFit.cover,
                    //   image: AssetImage(images[index]),
                    // ),
                    border: Border.all(
                      width: selectedColorIdx == index ? 5 : 0,
                      color: selectedColorIdx == index ? Colors.red : Colors.transparent
                    ),
                  ),
                  child: Image.asset(images[index]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesc({required Diary? diary}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        controller: controller,
        maxLines: 10,
        style: const TextStyle(
          fontSize: 24,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText: (diary == null || diary.desc == '')
              ? KeyAndString.dailyDiaryDescHintText
              : '',
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
        ),
        onChanged: (text) {
          controller.text = text;
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
        },
      ),
    );
  }

  Future<void> _saveDiary(
      DailyDiaryViewModel diaryViewModel,
      AdventureViewModel adventureViewModel,
      WeekDiariesViewModel weekDiariesViewModel) async {
    final state = diaryViewModel.state;
    final inputText = controller.text;
    final newDiary = Diary(
      emotion: selectedColorIdx,
      picture: '',
      desc: inputText,
      date: state.diary!.date,
    );
    if (selectedColorIdx == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          content: Text(KeyAndString.dailySaveFailed),
        ),
      );
      return;
    }
    await diaryViewModel.saveDiary(diary: newDiary);
    await adventureViewModel.checkIsOkayToMakeOrUseItem();
    await weekDiariesViewModel.getWeekDiaries();

    if (!mounted) return;
    Navigator.pop(context, KeyAndString.dailyDiarySaved);
  }
}
