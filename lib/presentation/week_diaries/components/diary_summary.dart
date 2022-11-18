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

  final images = [
    'assets/images/kotori_sad_face.png',
    'assets/images/kotori_little_sad_face.png',
    'assets/images/kotori_normal_face.png',
    'assets/images/kotori_little_good_face.png',
    'assets/images/kotori_good_face.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isFold = !isFold;
          });
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTitle(),
              if (!isFold) _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Image.asset(images[widget.diary.emotion]),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.diary.date.toString().split(' ').first,
              style: const TextStyle(
                  fontSize: 18, fontFamily: 'KyoboHandwriting2019'),
            ),
          ),
          if (widget.diary.desc.isNotEmpty)
            Icon(isFold ? Icons.arrow_drop_down : Icons.arrow_drop_up),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
      child: Row(
        children: [
          Text(
            widget.diary.desc,
            style: const TextStyle(
                fontSize: 20, height: 1.5, fontFamily: 'KyoboHandwriting2019'),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
