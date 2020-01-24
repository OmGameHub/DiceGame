import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter/services.dart';

import 'Player.dart';

class MyHomePage extends StatefulWidget {

  final Player player1;
  final Player player2;

  MyHomePage(this.player1, this.player2);

  @override
  _MyHomePageState createState() => _MyHomePageState(this.player1, this.player2);
}

class _MyHomePageState extends State<MyHomePage> {

  static AudioCache audio = AudioCache(prefix: 'audio/');

  var diceList = [
    AssetImage("assets/images/dice1.png"),
    AssetImage("assets/images/dice2.png"),
    AssetImage("assets/images/dice3.png"),
    AssetImage("assets/images/dice4.png"),
    AssetImage("assets/images/dice5.png"),
    AssetImage("assets/images/dice6.png"),
  ];

  Player player1;
  Player player2;

  bool isGameOver;

  int currentTime = 10;
  int maxTime = 10;
  String displayMessage = "";

  Timer timer;

  _MyHomePageState(this.player1, this.player2);

  @override
  void initState() {
    isGameOver = false;

    setState(() {
      player1.turn = 3;
      player2.turn = 3;

      player1.isMyTurn = Random().nextBool();
      player2.isMyTurn = !player1.isMyTurn;

      displayMessage = "Time: 10";
    });

    resetTimer();

    super.initState();
  }
  
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
  
  void restartGame()
  {
    setState(() {
      player1.score = 0;
      player2.score = 0;

      player1.turn = 3;
      player2.turn = 3;

      player1.isMyTurn = Random().nextBool();
      player2.isMyTurn = !player1.isMyTurn;

      isGameOver = false;

      displayMessage = "Time: 10";
    });

    changeTurn();
  }

  void changeTurn()
  {
    setState(() 
    {  
      player1.isMyTurn = !player1.isMyTurn;
      player2.isMyTurn = !player1.isMyTurn;

      if (player1.turn <= 0 && player2.turn <= 0) 
      {
        isGameOver = true;
        checkWin();
        _showkWin();
      }
    });

    resetTimer();
  }

  void checkWin()
  {
    setState(() { 
      if (player1.score == player2.score) 
      {
        player1.isWin = false;
        player2.isWin = false;
        displayMessage = "It's Draw";
      } 
      else 
      {
        if (player1.score > player2.score) 
        {
          player1.isWin = true;
          player2.isWin = false;
          displayMessage = "${player1.name} Win!";
        }
        else
        {
          player1.isWin = false;
          player2.isWin = true;
          displayMessage = "${player2.name} Win!";
        }

        audio.play('winner.wav');
      }
    });
  }

  Widget playerLogo(Player player) => 
  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[

      Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            backgroundImage: player.image == null ? null : FileImage(player.image),
            child: player.image == null ? Icon(Icons.account_circle, size: 64) : Container(),
          ),

          player.isWin?
            Icon(
              Icons.star,
              size: 28,
              color: Colors.yellow,
            ) : Container(),
        ],
      ),

      Container(height: 5),

      Text(
        "${player.name} \nScore: ${player.score}",
        textAlign: TextAlign.center,
      ),
    ],
  );
  
  Future<void> _showkWin() async 
  {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            displayMessage,
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      playerLogo(player1),

                      playerLogo(player2),

                    ],
                  ),
                ),
                
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Restart game'),
              onPressed: () {
                restartGame();
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              child: Text('Quit game'),
              onPressed: () {
                Navigator.of(context).pop();
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),

          ],
        );
      },
    );
  }

  void resetTimer() 
  {
    if (timer != null) 
      timer.cancel();

    if (!isGameOver) 
    {
      currentTime = maxTime;
      timer =  Timer.periodic(
        Duration(seconds: 1), 
        (Timer timer) 
        {
          setState(() 
          {
            currentTime--;

            if (currentTime > 5) 
              audio.play('timer.wav');
            else
              audio.play('urgent_timer.wav');

            displayMessage = "Time: $currentTime";

            if (currentTime <= 0) 
            {
              if (player1.isMyTurn) 
                player1.turn--;
              else
                player2.turn--;

              changeTurn();
            }

          });
        }
      );  
    }
  }
 
  void spinDice(Player player)
  {
    if (!isGameOver) 
    {
      int random = Random().nextInt(diceList.length);
      audio.play('dice.wav');
      setState(() 
      { 
        player.diceIndex = random; 
        player.score += random + 1;
        player.turn--;
      });

      changeTurn();
    }
  } 
  
  Widget displayText(String text) => 
  Text(
    text,
    style: TextStyle(
      fontSize: 20, 
      color: Colors.white, 
      fontWeight: FontWeight.bold
    ),
  );
  
  Widget playerPanel(Player player, VerticalDirection verticalDirection) => 
  Expanded(
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        verticalDirection: verticalDirection,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          // palyer socer & turn left
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    displayText("${player.name}"),
                    displayText("Score: ${player.score}"),
                  ],
                ),

                displayText("Turn: ${player.turn}"),

              ],
            ),
          ),

          // player dice
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              verticalDirection: verticalDirection,
              children: <Widget>[

                player.isMyTurn ?

                FlatButton(
                  child: Image(
                    width: 120,
                    height: 120,
                    image: diceList[player.diceIndex],
                  ),
                  splashColor: Colors.transparent,  
                  highlightColor: Colors.transparent,
                  onPressed: () 
                  {
                    if (player.isMyTurn) 
                      spinDice(player);
                  },
                ) :
                displayText("Wait!"),
                
              ],
            ),
          )

        ],
      ),
    ),
  );  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[

              // player one panel
              playerPanel(player1, VerticalDirection.down),

              // divider
              Container(height: 1, width: double.infinity, color: Colors.white),

              // score panel 
              Container(
                width: double.infinity,
                color: Colors.black12,
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                child: displayText(displayMessage),
                  
              ),

              // divider
              Container(height: 1, width: double.infinity, color: Colors.white),

              // player two panel
              playerPanel(player2, VerticalDirection.up),

            ],
          ),
        ),
      ),
    );
  }
}