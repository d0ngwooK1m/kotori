import 'package:flutter/material.dart';
import 'package:kotori/presentation/instruction/component/instruction_page.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({Key? key}) : super(key: key);

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {

  int selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          '설명서',
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildPager(),
          const SizedBox(height: 32),
          InstructionPage(index: selectedIdx),
        ],
      ),
    );
  }

  Widget _buildPager() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
                onTap: () async {
                  setState(() {
                    selectedIdx -= 1;
                  });
                },
                child: const Icon(
                  Icons.arrow_left,
                  size: 36,
                ),
              ),
        const SizedBox(width: 16),
        Text(
          '${selectedIdx + 1} / 8',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 16),
        selectedIdx == 8
            ? const Padding(
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.arrow_right,
                  size: 36,
                  color: Colors.grey,
                ),
              )
            : GestureDetector(
                onTap: () async {
                  setState(() {
                    selectedIdx += 1;
                  });
                },
                child: const Icon(
                  Icons.arrow_right,
                  size: 36,
                ),
              ),
      ],
    );
  }
}
