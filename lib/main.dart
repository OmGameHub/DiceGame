import 'package:flutter/material.dart';
import 'package:dice_game/StartPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dice Game",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: StartPage(),
    );
  }
}