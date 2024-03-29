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
  String _txtQuestion = "";
  String _txtAnswer = "";
  bool _isMemorised = false;
  bool _isQuestionCardVisible = false;
  bool _isAnswerCardVisible = false;
  bool _isCheckBoxVisible = false;
  bool _isFabVisible = false;

  List<Word> _testDataList = [];
  TestStatus? _testStatus;

  int _index = 0; //今何問目か
  late Word _currentWord;

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
      _isQuestionCardVisible = false;
      _isAnswerCardVisible = false;
      _isCheckBoxVisible = false;
      _isFabVisible = true;
      _numberOfQuestion = _testDataList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _finishTestScreen(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("かくにんテスト"),
          centerTitle: true,
        ),
        floatingActionButton: _isFabVisible
            ? FloatingActionButton(
                onPressed: () => _goNextStatus(),
                child: const Icon(Icons.skip_next),
                tooltip: "次にすすむ",
              )
            : null,
        body: Stack(
          children: [
            Column(
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
            _endMessage(),
          ],
        ),
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
    if (_isQuestionCardVisible) {
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
    } else {
      return Container();
    }
  }

  //こたえカード表示部分
  Widget _answerCardPart() {
    if (_isAnswerCardVisible) {
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
    } else {
      return Container();
    }
  }

  //暗記済みチェック部分
  Widget _isMemorizedCheckPart() {
    if (_isCheckBoxVisible) {
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
    } else {
      return Container();
    }
  }

  Widget _endMessage() {
    if (_testStatus == TestStatus.FINISHED) {
      return const Center(
        child: Text(
          "テスト終了",
          style: TextStyle(
            fontSize: 50.0,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  _goNextStatus() async {
    switch (_testStatus) {
      case TestStatus.BEFORE_START:
        _testStatus = TestStatus.SHOW_QUESTION;
        _showQuestion();
        break;
      case TestStatus.SHOW_QUESTION:
        _testStatus = TestStatus.SHOW_ANSWER;
        _showAnswer();
        break;
      case TestStatus.SHOW_ANSWER:
        await _updateMemorizedFlag();
        if (_numberOfQuestion <= 0) {
          setState(() {
            _isFabVisible = false;
            _testStatus = TestStatus.FINISHED;
          });
        } else {
          _testStatus = TestStatus.SHOW_QUESTION;
          _showQuestion();
        }
        break;
      case TestStatus.FINISHED:
        break;
    }
  }

  void _showQuestion() {
    _currentWord = _testDataList[_index];
    setState(
      () {
        _isQuestionCardVisible = true;
        _isAnswerCardVisible = false;
        _isCheckBoxVisible = false;
        _isFabVisible = true;
        _txtQuestion = _currentWord.strQuestion;
      },
    );
    _numberOfQuestion -= 1;
    _index += 1;
  }

  void _showAnswer() {
    setState(
      () {
        _isQuestionCardVisible = true;
        _isAnswerCardVisible = true;
        _isCheckBoxVisible = true;
        _isFabVisible = true;
        _txtAnswer = _currentWord.strAnswer;
        _isMemorised = _currentWord.isMemorized;
      },
    );
  }

  Future<void> _updateMemorizedFlag() async {
    var updateWord = Word(
      strQuestion: _currentWord.strQuestion,
      strAnswer: _currentWord.strAnswer,
      isMemorized: _isMemorised,
    );
    await database.updateWord(updateWord);
  }

  Future<bool> _finishTestScreen() async {
    return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("テストの終了"),
            content: const Text("テストをしてもいいですか？"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("はい"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("いいえ"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
