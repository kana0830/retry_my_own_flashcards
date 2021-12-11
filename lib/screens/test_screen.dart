import 'package:flutter/material.dart';

enum TestStatus { BEFORE_START, SHOW_QUESTION, SHOW_ANSWER, FINISHED }

class TestScreen extends StatefulWidget {
  final bool isIncludedMemorizedWords;

  TestScreen({required this.isIncludedMemorizedWords});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _numberOfQuestion = 0;
  String _txtQuestion = "テスト";
  String _txtAnswer = "こたえ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("かくにんテスト"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("FAB"), //TODO
        child: const Icon(Icons.skip_next),
        tooltip: "次にすすむ",
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          _numberOfQuestionPart(),
          const SizedBox(
            height: 60.0,
          ),
          _questionCardPart(),
          const SizedBox(
            height: 20.0,
          ),
          _answerCardPart(),
          _isMemorizedCheckPart(),
        ],
      ),
    );
  }

  //残り問題数表示部分
  Widget _numberOfQuestionPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "のこり問題数",
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        const SizedBox(
          width: 30.0,
        ),
        Text(
          _numberOfQuestion.toString(),
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  //TODO 問題カード表示部分
  Widget _questionCardPart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset("assets/images/image_flash_question.png"),
        Text(
          _txtQuestion,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  //TODO こたえカード表示部分
  Widget _answerCardPart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset("assets/images/image_flash_answer.png"),
        Text(
          _txtAnswer,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  //TODO 暗記済みチェック部分
  Widget _isMemorizedCheckPart() {
    return Container();
  }
}
