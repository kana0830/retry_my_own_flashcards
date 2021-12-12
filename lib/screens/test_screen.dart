import 'package:flutter/material.dart';
import 'package:retry_my_own_flashcards/db/database.dart';
import 'package:retry_my_own_flashcards/main.dart';

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
  bool _isMemorised = false;
  List<Word> _testDataList = [];
  late TestStatus _testStatus;

  @override
  void initState() {
    super.initState();
    _getTestData();
  }

  void _getTestData() async {
    if (widget.isIncludedMemorizedWords) {
      _testDataList = await database.allWords;
    } else {
      _testDataList = await database.allWordsExcludedMemorized;
    }
    _testDataList.shuffle();
    _testStatus = TestStatus.BEFORE_START;
    setState(() {
      _numberOfQuestion = _testDataList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("かくにんテスト"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goNextStatus(),
        child: const Icon(Icons.skip_next),
        tooltip: "次にすすむ",
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 80.0,
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
          const SizedBox(
            height: 40.0,
          ),
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
          width: 24.0,
        ),
        Text(
          _numberOfQuestion.toString(),
          style: const TextStyle(
            fontSize: 30.0,
          ),
        ),
      ],
    );
  }

  //問題カード表示部分
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

  //こたえカード表示部分
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

  //暗記済みチェック部分
  Widget _isMemorizedCheckPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CheckboxListTile(
        title: const Text(
          "暗記済みにする場合はチェックを入れて下さい",
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        value: _isMemorised,
        onChanged: (value) {
          setState(
            () {
              _isMemorised = value!;
            },
          );
        },
      ),
    );
  }

  _goNextStatus() {
    switch (_testStatus) {
      case TestStatus.BEFORE_START:
        _testStatus = TestStatus.SHOW_QUESTION;
        break;
      case TestStatus.SHOW_QUESTION:
        _testStatus = TestStatus.SHOW_ANSWER;
        break;
      case TestStatus.SHOW_ANSWER:
        if (_numberOfQuestion <= 0) {
          _testStatus = TestStatus.FINISHED;
        } else {
          _testStatus = TestStatus.SHOW_QUESTION;
        }
        break;
      case TestStatus.FINISHED:
        break;
    }
  }
}
