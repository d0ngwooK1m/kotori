import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreen({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'error : $errorMessage\n\n문제가 발생했어요... 앱을 껐다 켜거나 재설치를 했는데도 문제가 발생한다면 다음 화면을 캡쳐해서 dongwookim.dev@gmail.com으로 문의주세요',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 36),
          Image.asset('assets/images/kotori_sad_face.png'),
        ],
      ),
    );
  }
}
