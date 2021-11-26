import 'package:flutter/material.dart';
import 'package:retry_my_own_flashcards/parts/button_with_icon.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isIncludedMemorizedWord = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Image.asset("assets/images/image_title.png")),
            titleText(),
            const Divider(
              color: Colors.white,
              height: 30.0,
              indent: 8.0,
              endIndent: 8.0,
            ),
            const SizedBox(
              height: 30.0,
            ),
            ButtonWithIcon(
              onPressed: () => print("かくにんテスト"),
              icon: const Icon(Icons.play_arrow),
              label: "かくにんテストをする",
              color: Colors.brown,
            ),
            const SizedBox(
              height: 10.0,
            ),
            _radioButons(),
            const SizedBox(
              height: 30.0,
            ),
            ButtonWithIcon(
              onPressed: () => print("単語一覧"),
              icon: const Icon(Icons.list),
              label: "単語一覧を見る",
              color: Colors.grey,
            ),
            const SizedBox(
              height: 80.0,
            ),
            const Text(
              "powered by Kana",
              style: TextStyle(fontFamily: "Mont"),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget titleText() {
    return Column(
      children: const [
        Text(
          "私だけの単語帳",
          style: TextStyle(
            fontSize: 40.0,
          ),
        ),
        Text(
          "My Own Flashcards",
          style: TextStyle(
            fontSize: 26.0,
            fontFamily: "Mont",
          ),
        ),
      ],
    );
  }

  Widget _radioButons() {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Column(
        children: [
          RadioListTile(
            title: const Text(
              "暗記済みの単語を除外する",
              style: TextStyle(fontSize: 16.0),
            ),
            value: false,
            groupValue: isIncludedMemorizedWord,
            onChanged: (value) => _onRadioSelected(value),
          ),
          RadioListTile(
            title: const Text(
              "暗記済みの単語を含む",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: isIncludedMemorizedWord,
            onChanged: (value) => _onRadioSelected(value),
          ),
        ],
      ),
    );
  }

  _onRadioSelected(value) {
    setState(
      () {
        isIncludedMemorizedWord = value;
      },
    );
  }
}
