import 'package:flutter/material.dart';

class InstructionPage extends StatelessWidget {
  final int index;

  const InstructionPage({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> texts = [
      '코토리는 여러분의 기분의 높낮이로 이루어진 산을 여행하는 조그만 새입니다\n\n코토리는 기분 일지를 작성하고 그걸 바탕으로 기분의 모양을 산 모양의 지도로 그리는 역할을 맡고 있습니다',
      '최초로 앱을 실행시켰을 때 나타나는 화면입니다\n\n아래쪽에 탭이 2개, 가운데 버튼이 하나 보일텐데요, 버튼은 기분 일지 페이지로 가는 버튼입니다\n\n\'모험\' 탭은 코토리가 작성한 일지 내용에 따라 아이템을 저장 및 사용할 수 있는 탭입니다\n\n\'지도\' 탭은 코토리가 작성한 일지를 일주일 씩 모아 기분이 어떻게 변하는지 보여주는 탭입니다',
      '코토리에 배낭 안에 있는 아이템을 터치하면 나오는 화면입니다\n\n자신이 좋아하는 아이템을 선택할 수 있으며, 힘들 때 무슨 일을 하고 싶은지 적어주시면 됩니다\n\n생각이 잘 나지 않는다면 왼쪽 아래 전구 버튼을 눌러서 추천을 받아보세요! 추천 내용을 나에게 맞는 방법으로 수정하는 것도 좋아요\n\n다 작성하셨다면 오른쪽 아래 저장버튼을 눌러 저장할 수 있습니다',
      '가운데 버튼을 터치하면 나오는 기분 일지 페이지 입니다\n\n오늘 여러분이 느낀 기분을 표현하는 코토리 표정을 선택해주신 다음 오늘 왜 이런 기분을 느꼈는지 적어주시고(선택사항) 저장버튼을 눌러주시면 됩니다',
      '일지를 저장했을 때 기분이 보통 초과면 다음과 같은 화면이 나옵니다\n\n코토리가 새로운 아이템을 발견할 수 있으며, 이것을 배낭 안으로 드래그 하여 저장할 수 있습니다',
      '일지를 저장했을 때 기분이 보통 미만이면 다음과 같은 화면이 나옵니다\n\n코토리가 휴식을 취하고 있으며, 내가 저장한 아이템을 드래그 하여 주면 코토리는 그것을 먹거나 가지고 놀며 다시 여행할 힘을 얻습니다\n\n아이템에 적혀있는 내용을 나도 실행하면서 기운을 회복해 보시는 것을 추천합니다!\n\n충분히 휴식하셨다면 가운데 버튼을 터치하여 다 쉬었다고 코토리에게 말해주세요',
      '아이템이 너무 많아 삭제하고 싶다면 코토리의 뒤쪽에 있는 사각형에 아이템을 드래그하여 놓고, 가운데 버튼을 터치하여 아이템을 버리겠다고 하시면 됩니다',
      '\'지도\'탭을 터치하면 나오는 화면입니다\n\n나의 일주일간 감정의 변화가 코토리가 기록한 지도로 나타나며, 일주일간 저장한 일지도 모아서 확인할 수 있습니다',
      '여러분의 기분이 코토리와 함께 힘들 때는 조금 더 나은 기분으로, 좋을 때는 힘든 순간을 잘 대비하길 바라며 앱을 만들었습니다\n\n작은 도움이 되면 좋겠습니다\n\n앱을 사용하면서 문제가 발생하거나 불편하신 점, 또는 건의할 것이 있다면 dongwookim.dev@gmail.com으로 문의 메일을 주세요',
    ];

    final List<String> images = [
      'assets/images/kotori_logo.png',
      'assets/images/instruction_one.jpg',
      'assets/images/instruction_two.jpg',
      'assets/images/instruction_three.jpg',
      'assets/images/instruction_four.jpg',
      'assets/images/instruction_five.jpg',
      'assets/images/instruction_six.jpg',
      'assets/images/instruction_seven.jpg',
      'assets/images/kotori_little_good_face.png',
    ];

    return Expanded(
      child: ListView(
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Text(texts[index], style: const TextStyle(fontSize: 16),)),
          const SizedBox(height: 32),
          Image.asset(images[index]),
        ],
      ),
    );
  }
}
