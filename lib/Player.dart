import 'dart:io';

class Player
{
  int playerIndex;
  String name;
  int diceIndex;
  int score;
  int turn;
  String message;
  File image;

  bool isMyTurn = false;
  bool isWin = false;

  Player(int playerIndex)
  {
    this.playerIndex = playerIndex;
    diceIndex = 0;
    score = 0;
    turn = 3;
    message = "";
  }
}