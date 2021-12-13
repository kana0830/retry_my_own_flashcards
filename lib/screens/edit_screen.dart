import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:retry_my_own_flashcards/db/database.dart';
import 'package:retry_my_own_flashcards/main.dart';
import 'package:retry_my_own_flashcards/screens/word_list_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum EditStatus { ADD, EDIT }

class EditScreen extends StatefulWidget {
  final EditStatus status;
  final Word? word;

  EditScreen({required this.status, this.word});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  String _titleText = "";

  bool _isQuestionEnabeled = true;

  @override
  void initState() {
    super.initState();
    if (widget.status == EditStatus.ADD) {
      _isQuestionEnabeled = true;
      _titleText = "新しい単語の登録";
      questionController.text = "";
      answerController.text = "";
    } else {
      _isQuestionEnabeled = false;
      _titleText = "登録した単語の修正";
      questionController.text = widget.word!.strQuestion;
      answerController.text = widget.word!.strAnswer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backToWordListScreen(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titleText),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => _onWordRegistered(),
              icon: const Icon(Icons.done),
              tooltip: "登録",
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30.0,
              ),
              const Center(
                child: Text(
                  "問題と答えを入力して「登録」ボタンを押してください",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              _questionInputPart(),
              const SizedBox(
                height: 50.0,
              ),
              _answerInputPart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _questionInputPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          const Text(
            "問題",
            style: TextStyle(fontSize: 24.0),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            enabled: _isQuestionEnabeled,
            controller: questionController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _answerInputPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          const Text(
            "こたえ",
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: answerController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30.0,
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _backToWordListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WordListScreen(),
      ),
    );
    return Future.value(false);
  }

  _insertWord() async {
    if (questionController.text == "" || answerController.text == "") {
      Fluttertoast.showToast(
        msg: "問題と答えの両方を入力しないと登録できません。",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("登録"),
        content: const Text("登録していいですか？"),
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: () async {
              var word = Word(
                strQuestion: questionController.text,
                strAnswer: answerController.text,
                isMemorized: false,
              );
              try {
                await database.addWord(word);
                questionController.clear();
                answerController.clear();
                Fluttertoast.showToast(
                  msg: "登録が完了しました",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
              } on SqliteException catch (e) {
                Fluttertoast.showToast(
                  msg: "この問題はすでに登録されていますので登録できません。",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
              } finally {
                Navigator.pop(context);
              }
            },
            child: const Text("はい"),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("いいえ"),
          ),
        ],
      ),
    );
  }

  _onWordRegistered() {
    if (widget.status == EditStatus.ADD) {
      _insertWord();
    } else {
      _updateWord();
    }
  }

  void _updateWord() async {
    if (questionController.text == "" || answerController.text == "") {
      Fluttertoast.showToast(
        msg: "問題と答えの両方を入力しないと登録できません。",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("${questionController.text}の変更"),
        content: const Text("変更してもいいですか？"),
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: () async {
              var word = Word(
                strQuestion: questionController.text,
                strAnswer: answerController.text,
                isMemorized: false,
              );
              try {
                await database.updateWord(word);
                Navigator.pop(context);
                _backToWordListScreen();
                Fluttertoast.showToast(
                  msg: "修正が完了しました。",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
              } on SqliteException catch (e) {
                Fluttertoast.showToast(
                  msg: "何らかの問題が発生して登録できませんでした。 :$e",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
                Navigator.pop(context);
              }
            },
            child: const Text("はい"),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("いいえ"),
          ),
        ],
      ),
    );
  }
}
