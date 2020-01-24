import 'package:dice_game/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'Player.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  TextEditingController inputController1 = TextEditingController();
  TextEditingController inputController2 = TextEditingController();

  Player player1 = Player(1);
  Player player2 = Player(2);

  Future getImage(Player player) async 
  {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      player.image = image;
    });
  }

  void startGame()
  {
    String playerName1 = inputController1.text.trim();
    String playerName2 = inputController2.text.trim();

    setState(() {
      player1.name = playerName1.isEmpty ? "Player 1" : playerName1;
      player2.name = playerName2.isEmpty ? "Player 2" : playerName2;
    });
    
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (BuildContext context) => MyHomePage(player1, player2)
      )
    );
  }

  Widget playerInput(Player player, TextEditingController controller) => 
  Container(
    width: double.infinity,
    child: Row(
      children: <Widget>[

        GestureDetector(
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Colors.transparent,
            backgroundImage: player.image == null ? null : FileImage(player.image),
            child: player.image == null ? Icon(Icons.account_circle, size: 64) : Container(),
          ),
          onTap: () => getImage(player),
        ),

        Container(width: 10,),

        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: "Player ${player.playerIndex} name",
            ),
          ),
        )

      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.casino,
                  size: 100,
                ),

                Text(
                  "Dice Game",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                  ),
                ),

                Container(height: 42),

                playerInput(player1, inputController1),

                Container(height: 16,),

                playerInput(player2, inputController2),

                Container(height: 32,),

                Container(
                  width: double.infinity,
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(width: 1, color: Colors.white),
                    ),
                    child: Text(
                      "Start game",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: startGame,
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}