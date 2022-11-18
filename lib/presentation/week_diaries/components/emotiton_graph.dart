import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:kotori/domain/model/diary.dart';
import 'package:kotori/presentation/week_diaries/week_diaries_view_model.dart';
import 'package:provider/provider.dart';

class EmotionGraph extends StatelessWidget {

  const EmotionGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeekDiariesViewModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 5),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/back_ground_without_ground.png'),
          )
        ),
        width: 400,
        height: 250,
        child: CustomPaint(
          painter: GraphPainter(viewModel.state.weekDiaries, context),
        ),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<Diary?> weekDiaries;
  final BuildContext context;

  final int upperValue = 5;
  final int lowerValue = 0;
  final double spacing = 50;

  late Color textColor;
  final Color graphColor = Colors.green;
  late Paint strokePaint;
  late TextPainter horizontalTp;
  late TextPainter verticalTp;

  GraphPainter(this.weekDiaries, this.context) {
    strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    textColor = Theme.of(context).colorScheme.secondary;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paintHorizontalTp(canvas, size);
    _paintVerticalTp(canvas, size);
    _drawGraphLineAndFillPath(canvas, size);
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) {
    return oldDelegate.weekDiaries != weekDiaries;
  }

  void _paintHorizontalTp(Canvas canvas, Size size) {
    final days = [
      '월',
      '화',
      '수',
      '목',
      '금',
      '토',
      '일',
    ];

    for (var i = 0; i < 7; i++) {
      final textSpan = TextSpan(
          text: days[i],
          style: TextStyle(
            fontSize: 12,
            color: textColor,
          ));

      horizontalTp = TextPainter(
        text: textSpan,
        textAlign: TextAlign.start,
        textDirection: TextDirection.ltr,
      );

      horizontalTp.layout();
      horizontalTp.paint(canvas,
          Offset((i * size.width / 6), size.height + horizontalTp.height));
    }
  }

  void _paintVerticalTp(Canvas canvas, Size size) {
    for (var i = 0; i < 6; i++) {
      if (i <= 0) continue;
      final textSpan = TextSpan(
        text: (i - 3).toString(),
        style: TextStyle(
          fontSize: 12,
          color: textColor,
        ),
      );

      verticalTp = TextPainter(
          text: textSpan,
          textAlign: TextAlign.start,
          textDirection: TextDirection.ltr);

      verticalTp.layout();
      verticalTp.paint(canvas,
          Offset(i < 3 ? -verticalTp.width * 1.9 : -verticalTp.width * 2.5, size.height - (i * size.height / 5 * 0.7)));
    }
  }

  void _drawGraphLineAndFillPath(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height);

    final diaries = weekDiaries;
    for (var i = 0; i < 7; i++) {
      final emotion = diaries[i]?.emotion ?? -1;
      path.lineTo((i * size.width / 6),
          (size.height - (emotion + 1) * (size.height / 5 * 0.7)));
    }

    final fillPath = Path.from(path)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(0, size.height),
        Offset.zero,
        [
          Colors.green,
          Colors.white,
        ],
      );

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, strokePaint);
  }
}
