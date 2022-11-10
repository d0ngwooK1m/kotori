import 'package:flutter/material.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/presentation/daily_diary/daily_diary_state.dart';
import 'package:kotori/presentation/daily_diary/daily_diary_view_model.dart';
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
  final colors = [
    Colors.red,
    Colors.deepOrangeAccent,
    Colors.lime,
    Colors.greenAccent,
    Colors.green
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
    await viewModel.getDiary(now: Time.now);
    controller.text = viewModel.state.diary!.desc;
    if (viewModel.state.diary != null) {
      setState(() {
        selectedColorIdx = viewModel.state.diary!.emotion;
      });
    }
    super.didPush();
  }

  @override
  Future<void> didPop() async {
    final viewModel = context.read<DailyDiaryViewModel>();
    final diaryState = viewModel.state.diary!;
    final diary = Diary(
      emotion: selectedColorIdx,
      picture: diaryState.picture,
      desc: controller.text,
      date: diaryState.date,
    );
    await viewModel.saveDiary(diary: diary);
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DailyDiaryViewModel>();
    final state = viewModel.state;

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
        bottomNavigationBar: const SizedBox(height: kBottomNavigationBarHeight),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          key: KeyAndString.dailyDiarySaveButton,
          onPressed: () {
            _saveDiary(viewModel, state);
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
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
              padding: const EdgeInsets.symmetric(horizontal: 18),
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
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: selectedColorIdx == index ? 5 : 0,
                    ),
                    color: colors[index],
                  ),
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
        style: TextStyle(
          fontSize: 24,
        ),
        decoration: InputDecoration(
          hintText: (diary == null || diary.desc == '')
              ? KeyAndString.dailyDiaryDescHintText
              : '',
          focusedBorder: InputBorder.none,
        ),
        onChanged: (text) {
          controller.text = text;
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
        },
      ),
    );
  }

  void _saveDiary(DailyDiaryViewModel viewModel, DailyDiaryState state) {
    final inputText = controller.text;
    final newDiary = Diary(
        emotion: selectedColorIdx,
        picture: '',
        desc: inputText,
        date: state.diary!.date,
        isSaved: true);
    if (selectedColorIdx == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(KeyAndString.dailySaveFailed),
        ),
      );
      return;
    }
    viewModel.saveDiary(diary: newDiary);
    Navigator.pop(context, KeyAndString.dailyDiarySaved);
  }
}
