import 'package:flutter/material.dart';
import 'package:marcador_truco/models/player.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _textFieldController = TextEditingController(); 

  var _playerOne = Player(name: "",score: 0, victories: 0);
  var _playerTwo = Player(name: "",score: 0, victories: 0);
  
  @override
  void initState() {
    super.initState();
    _resetPlayers();
    
  }

  void _resetPlayer({Player player, bool resetVictories = true}) {
    setState(() {
      player.score = 0;
      if (resetVictories) player.victories = 0;
    });
  }

  void _resetPlayers({bool resetVictories = true}) {
    _resetPlayer(player: _playerOne, resetVictories: resetVictories);
    _resetPlayer(player: _playerTwo, resetVictories: resetVictories);
    _textFieldController.text = "";
  }

  void _resetPoints({bool resetPoints = true}) {
    _resetPlayer(player: _playerOne, resetVictories: false);
    _resetPlayer(player: _playerTwo, resetVictories: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Marcador Pontos (Truco!)"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _showDialogReset(
                
                  title: 'Zerar',
                  message:
                      'Tem certeza que deseja começar novamente a pontuação?',
                  resetAll: () {
                    _resetPlayers();
                  },
                  resetPoints: (){
                    _resetPoints();
                  },
                  cancel: (){},                
                  );                  
            },
            icon: Icon(Icons.refresh),
          ),          
        ],
      ),
      body: Container(padding: EdgeInsets.all(20.0), child: _showPlayers()),
    );
  }
  Widget _showPlayers() {
    return Row(
    mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[         
        _showPlayerBoard(_playerOne),
        _showPlayerBoard(_playerTwo),        
        ]
        );
  }

  Widget _showPlayerBoard(Player player) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[          
          _playersButton(player),          
          _showPlayerScore(player.score),
          _showPlayerVictories(player.victories),
          _showScoreButtons(player),
        ],
      ),
    );
  }

   Widget _playersButton(Player player) {
     if (player.name.isEmpty) {
            player.name = "insira um nome!";
          }
    return Row(
    mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,

        children: <Widget>[  
        new FlatButton(
          child: Text(player.name),
          color: Colors.white,
          onPressed: () => _displayDialog(context, player),                
        ),
        ]
    );
   }


   _displayDialog(BuildContext context, Player player) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Escolher nome do jogador'),
            content: TextFormField(
              controller: _textFieldController,                    
              decoration: InputDecoration(hintText: "Digite um nome"),                     
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  player.name = _textFieldController.text;
                  Navigator.of(context).pop();
                  setState(() {
                  _showPlayerBoard(_playerOne);                                 
                  });
                }
              ),
            ],
          );
        });
  }

  Widget _showPlayerVictories(int victories) {
    return Text(
      "vitórias ( $victories )",
      style: TextStyle(fontWeight: FontWeight.w300),
    );
  }

  Widget _showPlayerScore(int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52.0),
      child: Text(
        "$score",
        style: TextStyle(fontSize: 120.0),
      ),
    );
  }

  Widget _buildRoundedButton(
      {String text, double size = 52.0, Color color, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Container(
          color: color,
          height: size,
          width: size,
          child: Center(
              child: Text(
            text,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget _showScoreButtons(Player player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildRoundedButton(
          text: '-1',
          color: Colors.black.withOpacity(0.1),
          onTap: () {
            setState(() {
              if(player.score > 0)
              player.score--;
            });
            if (player.score == 12) {

              _showDialog(
                  title: 'Fim do jogo',
                  message: '${player.name} ganhou!',
                  resetAll: () {
                    setState(() {
                      player.victories++;
                    });
                    _resetPlayers(resetVictories: false);
                    
                  },
                  cancel: () {
                    setState(() {                      
                          player.score--;
                    });
                  });
            }
          },
        ),
        _buildRoundedButton(
          text: '+1',
          color: Colors.deepOrangeAccent,
          onTap: () {
            setState(() {
              if(player.score < 12)
              player.score++;
            });
            if(_playerOne.score == 11 && _playerTwo.score == 11){
              _showMensagemDialog(player);
            }
            if (player.score == 12) {
              _showDialog(
                  title: 'Fim do jogo',
                  message: '${player.name} ganhou!',
                  resetAll: () {
                    setState(() {
                      player.victories++;
                    });

                    _resetPlayers(resetVictories: false);
                  },
                  cancel: () {
                    setState(() {
                     
                        player.score--;
                    });
                  });
            }
          },
        ),
      ],
    );
  }
  void _showDialogReset({String title, String message, Function resetAll, Function resetPoints,
  Function cancel} ){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: (){
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
            FlatButton(
              child: Text("RESET ALL"),
              onPressed: (){
               Navigator.of(context).pop();
              if (resetAll != null) resetAll();
            },
            ),
            FlatButton(
              child: Text("RESET \nPOINTS"),
              onPressed: (){
                Navigator.of(context).pop();
                if(resetPoints != null) resetPoints();
              },
            ),
          ],
        );
      }
    );
  }


  void _showDialog(
      {String title, String message, Function resetAll, Function cancel}) 
      {
    showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (resetAll != null) resetAll();
              },              
            ),
          ],
        );
      },
    );
  }
  void _showMensagemDialog (Player player){
   showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Mão de ferro'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('É a Mão de Onze especial. Todos os jogadores recebem as cartas “cobertas”. Quem vencer a mão, vence a partida'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Voltar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  }
}
