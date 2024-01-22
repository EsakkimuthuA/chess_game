import 'package:chess_game/colors.dart';
import 'package:chess_game/engine/timer.dart';

import '../games/play_local.dart';
import 'piece_widget.dart';
import 'package:flutter/material.dart';
import 'chess_board.dart';
import 'player_bar.dart';

import 'dart:math' as math;
import 'dart:async';

import 'package:get_it/get_it.dart';
import 'game_logic.dart';
final logic = GetIt.instance<GameLogic>();

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  //GameLogic logic = GameLogicImplementation();
  void update() => setState(() => {});
  @override
  void initState() {
    logic.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    logic.removeListener(update);
    super.dispose();
  }

  int selectedTime = 1;
  // Widget _buildTimers() {
  //   if (logic.player1Timer.currentTime.inSeconds <= 0 || logic.player2Timer.currentTime.inSeconds <= 0) {
  //     _endGame(logic.turn());
  //
  //   }
  bool isDialogShown = false;

  Widget _buildTimers() {
    if (!isDialogShown &&
        (logic.player1Timer.currentTime.inSeconds <= 0 || logic.player2Timer.currentTime.inSeconds <= 0)) {
      isDialogShown = true;
      _endGame(logic.turn());
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Player 1: ${logic.player1Timer.currentTime.inMinutes}:${(logic.player1Timer.currentTime.inSeconds % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        Text(
          'Player 2: ${logic.player2Timer.currentTime.inMinutes}:${(logic.player2Timer.currentTime.inSeconds % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        DropdownButton<int>(
          value: selectedTime,
          onChanged: (int? value) {
            if (value != null) {
              setState(() {
                selectedTime = value;
                logic.updateTimers(Duration(minutes: selectedTime));
              });
            }
          },
         dropdownColor: Colors.blue,
          iconEnabledColor: Colors.white,
          items: [1,0,5, 10, 15, 20, 30].map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value minutes',style: TextStyle(color: Colors.white),),
            );
          }).toList(),
        ),
      ],
    );
  }
  Widget _buildMultiplayerBar(bool isMe, PieceColor color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            flex: 7,
            child: PlayerBar(isMe, color)
        ),
       // const Spacer(flex: 2),
       //  Flexible(
       //      flex: 7,
       //      child: RotatedBox(
       //          quarterTurns: 2,
       //          child: PlayerBar(!isMe, color)
       //      )
       //  ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainPlayerColor = logic.args.asBlack ? PieceColor.BLACK : PieceColor.WHITE;
    final secondPlayerColor = logic.args.asBlack ? PieceColor.WHITE : PieceColor.BLACK;

    bool isMainTurn = mainPlayerColor == logic.turn();
    if (logic.isPromotion && (logic.args.isMultiplayer || isMainTurn)) {
      Timer(const Duration(milliseconds: 100), () => _showPromotionDialog(context));
    } else if (logic.gameOver()) {
      print('Game is over');
      Timer(const Duration(milliseconds: 500), () => _showEndDialog(context));
    }

    return Scaffold(
      backgroundColor: color.navy1,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50,),
            Row(
              children: [
                MaterialButton(
                  height: 30,
                  minWidth: 60,
                  onPressed: (){
                  if (!logic.gameOver()) {
                    _showSaveDialog(context);
                  } else {
                    _showSaveDialog(context);
                   // Navigator.popUntil(context, (route) => route.isFirst);
                  }
                 },
                  color: Colors.white,
                  child: Text('Exit',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),),
                SizedBox(width: 80,),
                MaterialButton(
                  height: 30,
                  minWidth: 60,
                  onPressed:logic.canUndo() ? () => logic.undo() : null,
                  color: Colors.white,
                 child: Icon(Icons.undo,size: 30,),),
                SizedBox(width: 30,),
                MaterialButton(
                  height: 30,
                  minWidth: 60,
                  onPressed: logic.canRedo() ? () => logic.redo() : null,
                  color: Colors.white,
                  child: Icon(Icons.redo,size: 30,),),
              ],
            ),
            _buildTimers(),
            Container(
              height: 180, // Set your desired height
              width: double.infinity,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: logic.args.isMultiplayer
                    ? _buildMultiplayerBar(true, mainPlayerColor) //change the secondPlayerColor to MainPlayerColor
                    : PlayerBar(false, secondPlayerColor),
              ),
            ),
            // ignore: prefer_const_constructors
            ChessBoard(),
            Container(
              height: 180, // Set your desired height
              width: double.infinity,
              child: Align(
                alignment: Alignment.topCenter,
                child: logic.args.isMultiplayer
                    ? _buildMultiplayerBar(false, secondPlayerColor) // change the mainPlayerColor to SecondPlayerColor
                    : PlayerBar(true, mainPlayerColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _endGame([PieceColor? winner]) {
    // Future.microtask(() {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Game Over"),
            content: Text("Player ${winner == PieceColor.WHITE ? 2 : 1} wins!"),
            actions: [
              TextButton(
                onPressed: () {
                  final args = logic.args;
                  logic.clear();
                  args.asBlack = !args.asBlack;
                  logic.args = args;
                  Navigator.pop(context);
                    Navigator.pushNamed(context, '/game');
                    logic.start();
                },
                child: const Text("Rematch"),
              ),
              TextButton(
                onPressed: () {
                  logic.clear();
                  //Navigator.pop(context);
                  Navigator.of(context).popUntil((route) => route.isFirst);

                //  Navigator.popUntil(context, (route) => route.isFirst);
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PlayLocal()));
                },
                child: const Text("OK"),
              ),
            ],
          ));
    });
  }
  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
        AlertDialog(
          title: const Text("Exit"),
          content: const Text("Do you want to Exit this game?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // logic.clear();
                // Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                logic.clear();
                Navigator.popUntil(context, (route) => route.isFirst);
               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PlayLocal()));
               //  final game = logic.save();
               //  logic.clear();
               //  Navigator.popUntil(context, (route) => route.isFirst);
               //  final snackBar = SnackBar(
               //    backgroundColor: Theme.of(context).bottomAppBarColor ,
               //    content: Text(
               //      "The game has been saved as ${game.name}",
               //      style: TextStyle(color: Theme.of(context).primaryColorLight))
               //  );
               //  ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text("Yes"),
            ),
          ]
        )
    );
  }

  void _showEndDialog(BuildContext context) {
    var title = "";
    if (logic.inCheckmate()) {
      title = "Checkmate!\n${logic.turn() == PieceColor.WHITE ? "Black" : "White"} Wins";
    } else if (logic.inDraw()) {
      title = "Draw!\n";
      if (logic.insufficientMaterial()) {
        title += "By Insufficient Material";
      } else if (logic.inThreefoldRepetition()) {
        title += "By Repetition";
      } else if (logic.inStalemate()) {
        title += "By Stalemate";
      } else {
        title += "By the 50-move rule";
      }
    }else {
      title = "Time's up!\n${logic.turn() == PieceColor.WHITE ? "Black" : "White"} Wins";
    }

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(title: Text(title),actions: [
              TextButton(
                onPressed: () {
                  final args = logic.args;
                  logic.clear();
                  args.asBlack = !args.asBlack;
                  logic.args = args;
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/game');
                  logic.start();
                },
                child: const Text("Rematch"),
              ),
              TextButton(
                onPressed: () {
                  logic.clear();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("Exit"),
              )
            ]));
  }

  void _showPromotionDialog(BuildContext context) {
    var pieces = [
      PieceType.QUEEN,
      PieceType.ROOK,
      PieceType.BISHOP,
      PieceType.KNIGHT
    ].map((pieceType) => Piece(pieceType, logic.turn()));
    final asBlack = logic.args.asBlack;
    var futureValue = showDialog(
        context: context,
        builder: (BuildContext context) => Transform.rotate(
            angle: (logic.turn() == PieceColor.BLACK) != asBlack
                ? math.pi
                : 0,
            child: SimpleDialog(
                title: const Text('Promote to'),
               shadowColor: Colors.green,
                //backgroundColor: Colors.grey,
                surfaceTintColor: Colors.green,
                children: pieces
                          .map((piece) => SimpleDialogOption(
                            onPressed: () => Navigator.of(context).pop(piece),
                            child: SizedBox(
                              height: 60,
                              child: PieceWidget(piece: piece)
                            )))
                          .toList())));
    futureValue.then((piece) => logic.promote(piece));
  }
}
