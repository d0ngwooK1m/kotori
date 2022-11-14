import 'package:flutter/material.dart';
import 'package:kotori/domain/model/diary.dart';

class DiarySummary extends StatefulWidget {
  final Diary diary;

  const DiarySummary({Key? key, required this.diary}) : super(key: key);

  @override
  State<DiarySummary> createState() => _DiarySummaryState();
}

class _DiarySummaryState extends State<DiarySummary> {
  bool isFold = true;

  final colors = [
    Colors.red,
    Colors.deepOrangeAccent,
    Colors.lime,
    Colors.greenAccent,
    Colors.green
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(width: 3),
        ),
        child: Column(
          children: [
            _buildTitle(),
            if (!isFold) _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: colors[widget.diary.emotion],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.diary.date.toString().split(' ').first,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          if (widget.diary.desc.isNotEmpty) IconButton(
            onPressed: () {
              setState(() {
                isFold = !isFold;
              });
            },
            icon: Icon(isFold ? Icons.arrow_downward : Icons.arrow_upward),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(widget.diary.desc, style: const TextStyle(fontSize: 18),),
        const SizedBox(height: 20),
      ],
    );
  }
}
