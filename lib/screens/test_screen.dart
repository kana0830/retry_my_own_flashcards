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
            height: 10.0,
          ),
          _numberOfQuestionPart(),
          _questionCardPart(),
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
    return Container();
  }

  //TODO こたえカード表示部分
  Widget _answerCardPart() {
    return Container();
  }

  //TODO 暗記済みチェック部分
  Widget _isMemorizedCheckPart() {
    return Container();
  }
}
