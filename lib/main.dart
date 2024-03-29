import 'package:flutter/material.dart';
import 'package:retry_my_own_flashcards/db/database.dart';
import 'package:retry_my_own_flashcards/screens/home_screen.dart';

late MyDatabase database;

void main() {
  database = MyDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "私だけの単語帳",
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Lanobe",
      ),
      home: HomeScreen(),
    );
  }
}
