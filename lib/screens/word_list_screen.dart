import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retry_my_own_flashcards/db/database.dart';
import 'package:retry_my_own_flashcards/main.dart';

import 'edit_screen.dart';

class WordListScreen extends StatefulWidget {
  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Word> _wordList = [];

  @override
  void initState() {
    super.initState();
    _getAllWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("単語一覧"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewWord(),
        child: const Icon(Icons.add),
        tooltip: "新しい単語の登録",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _wordListWidget(),
      ),
    );
  }

  _addNewWord() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(
          status: EditStatus.ADD,
        ),
      ),
    );
  }

  void _getAllWords() async {
    _wordList = await database.allWords;
    setState(() {});
  }

  Widget _wordListWidget() {
    return ListView.builder(
      itemBuilder: (context, int position) => _wordItem(position),
      itemCount: _wordList.length,
    );
  }

  Widget _wordItem(int position) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: Colors.grey.shade700,
      child: ListTile(
        title: Text(
          _wordList[position].strQuestion,
        ),
        subtitle: Text(
          _wordList[position].strAnswer,
          style: const TextStyle(fontFamily: "Mont"),
        ),
        onLongPress: () => _deleteWord(_wordList[position]),
        onTap: () => _editWord(_wordList[position]),
      ),
    );
  }

  _deleteWord(Word selectedWord) async {
    await database.deleteWord(selectedWord);
    Fluttertoast.showToast(
      msg: "削除が完了しました",
      toastLength: Toast.LENGTH_LONG,
    );
    _getAllWords();
  }

  _editWord(Word selectedWord) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(
          word: selectedWord,
          status: EditStatus.EDIT,
        ),
      ),
    );
  }
}
