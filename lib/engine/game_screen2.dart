import '../screen/home_screen.dart';
import 'piece_widget.dart';
import 'package:flutter/material.dart';
import 'chess_board.dart';
import 'player_bar.dart';

import 'dart:math' as math;
import 'dart:async';
import 'package:chess_game/colors.dart';
import 'package:get_it/get_it.dart';
import 'game_logic.dart';
final logic = GetIt.instance<GameLogic>();

class GameScreen2 extends StatefulWidget {
  const GameScreen2({super.key});

  @override
  State<GameScreen2> createState() => _GameScreen2State();
}

class _GameScreen2State extends State<GameScreen2> {
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

  Widget _buildMultiplayerBar(isMe, PieceColor color) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              flex: 7,
              child: PlayerBar(isMe, color)
          ),
          // const Spacer(flex: 2),
          // Flexible(
          //     flex: 7,
          //     child: RotatedBox(
          //         quarterTurns: 2,
          //         child: PlayerBar(!isMe, color)
          //     )
          // ),
        ]
    );
  }
  Widget _buildMultiplayerBar2(isMe, PieceColor color) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              flex: 7,
              child: RotatedBox(
                  quarterTurns: 2,
                  child: PlayerBar(isMe, color)
              )),
          // const Spacer(flex: 2),
          // Flexible(
          //     flex: 7,
          //     child: RotatedBox(
          //         quarterTurns: 2,
          //         child: PlayerBar(!isMe, color)
          //     )
          // ),
        ]
    );
  }
  bool isPromotionDialogShown = false;
  bool showEndDialog =false;
  @override
  Widget build(BuildContext context) {
    final mainPlayerColor = logic.args.asBlack ? PieceColor.BLACK : PieceColor.WHITE;
    final secondPlayerColor = logic.args.asBlack ? PieceColor.WHITE : PieceColor.BLACK;

    bool isMainTurn = mainPlayerColor == logic.turn();
    if (logic.isPromotion && (logic.args.isMultiplayer || isMainTurn) && !isPromotionDialogShown) {
      isPromotionDialogShown = true;
      Timer(const Duration(milliseconds: 10), () => _showPromotionDialog(context));
    } else if (logic.gameOver() && !showEndDialog) {
      showEndDialog =true;
      Timer(const Duration(milliseconds: 500), () => _showEndDialog(context));
    }
    return Scaffold(
        backgroundColor: color.navy1,
        // appBar: AppBar(
        //     title: const Text('Chess Game'),
        //     leading: IconButton(
        //         icon: const Icon(Icons.arrow_back),
        //         onPressed: () {
        //           if (!logic.gameOver()) {
        //             _showSaveDialog(context);
        //           } else {
        //             Navigator.popUntil(context, (route) => route.isFirst);
        //           }
        //         }
        //     )
        // ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          SizedBox(height: 50,),
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
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child:
                      logic.args.isMultiplayer
                          ? _buildMultiplayerBar2(true, mainPlayerColor) //change the secondPlayerColor to MainPlayerColor
                          : Row(
                          children: [
                            Flexible(
                              flex: 7,
                              child: PlayerBar(false, secondPlayerColor), // change the mainPlayerColor to SecondPlayerColor
                           ),
                          //  const Spacer(flex: 9),
                          ]
                      )
                  )
              ),
              // ignore: prefer_const_constructors
              ChessBoard(),
              Expanded(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child:
                      logic.args.isMultiplayer
                          ? _buildMultiplayerBar(false, secondPlayerColor)
                          : Row(
                          children: [
                            Flexible(
                              flex: 7,
                              child: PlayerBar(true, mainPlayerColor),
                          ),
                         //   const Spacer(flex: 9),
                          ]
                      )

                  )
              )
            ]
        )
    );
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
                      final args = logic.args;
                      logic.clear();
                      args.asBlack = !args.asBlack;
                      logic.args = args;
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/game2');
                      logic.start();
                    },
                    child: const Text("Rematch"),
                  ),
                  TextButton(
                    onPressed: () {
                      logic.clear();
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
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
      title = "Checkmate!\n" +
          (logic.turn() == PieceColor.WHITE ? "Black" : "White") +
          " Wins";
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
    }

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(title: Text(title), actions: [
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                 // Navigator.popUntil(context, (route) => route.isFirst);
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
                children: pieces
                    .map((piece) => SimpleDialogOption(
                    onPressed: () => Navigator.of(context).pop(piece),
                    child: SizedBox(
                        height: 64,
                        child: PieceWidget(piece: piece)
                    )))
                    .toList())));
    futureValue.then((piece) {
      logic.promote(piece);
      isPromotionDialogShown = false; // Reset the flag
    });
  }
}
