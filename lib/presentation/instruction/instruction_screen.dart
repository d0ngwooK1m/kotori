import 'package:flutter/material.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({Key? key}) : super(key: key);

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  final List<Widget> pages = [];

  @override
  void initState() {
    pages.add(_buildPageOne());
    super.initState();
  }


  int selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Column(
        children: [
          Text('설명서'),
          _buildPager(),
        ],
      ),
    );
  }

  Widget _buildPager() {
    return Row(
      children: [
        selectedIdx == 0
            ? const Padding(
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.arrow_left,
                  size: 36,
                  color: Colors.grey,
                ),
              )
            : GestureDetector(
                onTap: () async {},
                child: const Icon(
                  Icons.arrow_left,
                  size: 36,
                ),
              ),
        Text(
          '${selectedIdx + 1} / n',
          style: const TextStyle(fontSize: 18),
        ),
        selectedIdx == pages.length - 1
            ? const Padding(
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.arrow_right,
                  size: 36,
                  color: Colors.grey,
                ),
              )
            : GestureDetector(
                onTap: () async {},
                child: const Icon(
                  Icons.arrow_right,
                  size: 36,
                ),
              ),
      ],
    );
  }

  Widget _buildPageOne() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('코토리는 여러분의 기분의 높낮이로 이루어진 산을 여행하는 조그만 새입니다.'),
        ],
      ),
    );
  }
}
