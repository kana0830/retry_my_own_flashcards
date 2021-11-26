import 'package:flutter/material.dart';
import 'package:retry_my_own_flashcards/parts/button_with_icon.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            ButtonWithIcon(
              onPressed: () => print("かくにんテスト"),
              icon: const Icon(Icons.play_arrow),
              label: "かくにんテストをする",
              color: Colors.brown,
            ),
            ButtonWithIcon(
              onPressed: () => print("単語一覧"),
              icon: const Icon(Icons.list),
              label: "単語一覧を見る",
              color: Colors.grey,
            ),
            const Text(
              "powered by Kana",
              style: TextStyle(fontFamily: "Mont"),
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
}
