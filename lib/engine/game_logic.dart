import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'game_arguments.dart';
import 'ai.dart';
import 'game_model.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:chess/chess.dart' as chess_lib;
import 'dart:math' as math;
final logic = GetIt.instance<GameLogic>();
typedef Piece = chess_lib.Piece;
typedef PieceType = chess_lib.PieceType;
typedef PieceColor = chess_lib.Color;

class ChessTimer {
  late Duration initialTime;
  late Duration currentTime;
  late Timer? _timer; // Nullable Timer

  ChessTimer(this.initialTime) {
    reset();
    _timer = null; // Initialize as null
  }

  void reset() {
    currentTime = initialTime;
  }

  void start(Function onTimerTick, Function onTimerFinished) {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
        if (currentTime.inSeconds > 0) {
          currentTime -= const Duration(seconds: 1);
          onTimerTick(); // Callback for each timer tick
        } else {
          timer.cancel();
          _timer = null; // Set the timer to null after finishing
          onTimerFinished(); // Callback when the timer finishes
        }
      });
  }

  void stop() {
    _timer?.cancel(); // Cancel the timer if it exists
    _timer = null; // Set the timer to null
  }
}


abstract class GameLogic extends ChangeNotifier {

  ChessTimer get player1Timer;
  ChessTimer get player2Timer;
  String? get selectedTile;
  List<String> get availableMoves;
  List<PieceType> get eatenBlack;
  List<PieceType> get eatenWhite;
  Map<String, String>? get previousMove; // 'from' and 'to' keys that point to positions on the board

  GameArguments args=GameArguments(asBlack: false, isMultiplayer: false);
  void updateTimers(Duration newTime);
  void maybeCallAI();
  String boardIndex(int rank, int file);
  void tapTile(String index);
  int getRelScore(PieceColor color);
  void clear();
  void start();
  Game save();
  void load(Game game);
  bool canUndo();
  bool canRedo();
  void undo();
  void redo();
  Piece? get(String index);
  String? squareColor(String index);
  PieceColor turn();
  bool gameOver();
  bool inCheckmate();
  bool inDraw();
  bool inThreefoldRepetition();
  bool insufficientMaterial();
  bool inStalemate();
  bool get isPromotion;
  void promote(Piece? selectedPiece);
}

class GameLogicImplementation extends GameLogic {
  late ChessTimer _player1Timer; // Rename here
  late ChessTimer _player2Timer; // Rename here
  GameLogicImplementation()
      : _player1Timer = ChessTimer(const Duration(minutes: 1)),
        _player2Timer = ChessTimer(const Duration(minutes: 1)) {
    chessHistory.add(chess.fen);
    _player1Timer.start(_onTimerTick, _onTimerFinished);
  }
  @override
  ChessTimer get player1Timer => _player1Timer; // Update here

  @override
  ChessTimer get player2Timer => _player2Timer; // Update here
  var chess = chess_lib.Chess();
  @override
  String? selectedTile;
  @override
  List<String> availableMoves = [];
  @override
  List<PieceType> eatenBlack = [];  // what black ate
  @override
  List<PieceType> eatenWhite = [];  // what white ate
  @override
  bool canUndo() => chessHistory.length > 1;
  @override
  bool canRedo() => chessRedoStack.isNotEmpty;
  @override
  void undo() {
    if (canUndo()) {
      chessRedoStack.add(chessHistory.removeLast());
      chess.load(chessHistory.last);
      notifyListeners();

    }
  }

  @override
  void redo() {
    if (canRedo()) {
      chess.load(chessRedoStack.removeLast());
      chessHistory.add(chess.fen);
      notifyListeners();
    }
  }

  @override
  // null means "this is a first move"
  // ignore: avoid_init_to_null
  Map<String, String>? previousMove = null;   // 'from' and 'to' keys that point to positions on the board

  @override
  bool get isPromotion => promotionMove != null;

  // null means "this move is not a promotion"
  // ignore: avoid_init_to_null
  var promotionMove = null;

  ChessAI ai = ChessAI();
  bool saveCurrentGame = false;

  List<String> chessHistory = [];
  List<String> chessRedoStack = [];



  static const boardFiles = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  @override
  String boardIndex(int rank, int file) {
    return boardFiles[file] + (rank+1).toString();
  }

  static  Map<chess_lib.PieceType, int> pieceScores = {
    PieceType.PAWN : 1,
    PieceType.KNIGHT : 3,
    PieceType.BISHOP : 3,
    PieceType.ROOK : 5,
    PieceType.QUEEN : 8,
    PieceType.KING : 999,
  };

  int _getScore(PieceColor color) {
    return chess.board
        .where((piece) => piece != null && piece.color == color)
        .map((piece) => pieceScores[piece!.type]).fold(0, (p, c) => p + c!);
  }
  @override
  int getRelScore(PieceColor color) {
    PieceColor otherColor = color == PieceColor.WHITE ? PieceColor.BLACK : PieceColor.WHITE;
    var mainPlayerScore = _getScore(color);
    var secondPlayerScore = _getScore(otherColor);
    return math.max(mainPlayerScore, secondPlayerScore) - secondPlayerScore;
  }

  @override
  Piece? get(String index) => chess.get(index);
  @override
  String? squareColor(String index) => chess.square_color(index);
  @override
  PieceColor turn() => chess.turn;
  @override
  bool gameOver() => chess.game_over;
  @override
  bool inCheckmate() => chess.in_checkmate;
  @override
  bool inDraw() => chess.in_draw;
  @override
  bool inThreefoldRepetition() => chess.in_threefold_repetition;
  @override
  bool insufficientMaterial() => chess.insufficient_material;
  @override
  bool inStalemate() => chess.in_stalemate;

  @override
  void updateTimers(Duration newTime) {
    _player1Timer = ChessTimer(newTime);
    _player2Timer = ChessTimer(newTime);
    notifyListeners();
  }
  void _startTimerForCurrentPlayer() {
    if (turn() == PieceColor.WHITE) {
      _player1Timer.start(_onTimerTick, _onTimerFinished);
    } else {
      _player2Timer.start(_onTimerTick, _onTimerFinished);
    }
  }

  void _onTimerTick() {
    // Callback for each timer tick
    notifyListeners();
  }
  void _onTimerFinished() {
    // Callback when the timer finishes
    if (gameOver()) {
      // Game is over, show the end dialog
      notifyListeners();
    } else {
      switchTurns();
      _startTimerForCurrentPlayer();
      notifyListeners();
    }
  }
  void switchTurns() {
    if (turn() == PieceColor.WHITE) {
      _player1Timer.stop();
      _player2Timer.reset();
    } else {
      _player2Timer.stop();
      _player1Timer.reset();
    }
  }

  void _addEatenPiece(Piece eatenPiece) {
      if (eatenPiece.color == PieceColor.BLACK) {
        eatenWhite.add(eatenPiece.type);
      } else {
        eatenBlack.add(eatenPiece.type);
      }
  }

  bool _move(move) {
    Piece? eatenPiece = chess.get(move['to']);
    bool isValid = chess.move(move);
    if (isValid) {
      if (eatenPiece != null) _addEatenPiece(eatenPiece);
      if (chess.turn == PieceColor.WHITE) {
        _player2Timer.stop();
        _player1Timer.start(_onTimerTick, _onTimerFinished);
        // _player1Timer.stop();
        // _player2Timer.start(_onTimerTick, _onTimerFinished);
      } else {
        _player1Timer.stop();
        _player2Timer.start(_onTimerTick, _onTimerFinished);
        //_player2Timer.stop();
        // _player1Timer.start(_onTimerTick, _onTimerFinished);
      }
      maybeCallAI();
      previousMove = {'from': move['from'], 'to': move['to']};
      chessHistory.add(chess.fen); // Save the board state to history
      chessRedoStack.clear(); // Clear redo stack when a new move is made
    }
    return isValid;
  }
  // bool _move(move) {
  //   Piece? eatenPiece = chess.get(move['to']);
  //   bool isValid = chess.move(move);
  //   if (isValid) {
  //     if (eatenPiece != null) _addEatenPiece(eatenPiece);
  //     maybeCallAI();
  //     previousMove = {'from': move['from'], 'to': move['to']};
  //   }
  //   return isValid;
  // }

  @override
  void maybeCallAI() async {
    if (!gameOver() && !args.isMultiplayer && !(args.asBlack == (chess.turn == PieceColor.BLACK))) {
      while (!ai.isReady()) {
        await Future.delayed(const Duration(seconds: 1));
      }
      var move = await ai.compute(chess.fen, args.difficultyOfAI, 1000);
      _move({'from': move[0]+move[1],
             'to': move[2]+move[3],
             'promotion': move.length == 5 ? move[4] : null});

      notifyListeners();
  }
}

  @override
  void promote(Piece? selectedPiece) {
    if (selectedPiece != null) {
      promotionMove['promotion'] = selectedPiece.type.toString();
      _move(promotionMove);
    }
    promotionMove = null;
    notifyListeners();

  }

  void makeMove(String fromInd, String toInd) {
    final move = {'from': fromInd, 'to': toInd};
    bool isValid = _move(move);
    if (!isValid && chess.move({'from': fromInd, 'to': toInd, 'promotion': 'q'})) {
      chess.undo();
      promotionMove = move;
    } else if (promotionMove != null) {
      promotionMove = null;
      return;
    }
  }

  void select(String? index) {
    selectedTile = index;
    availableMoves = chess
        .moves({'square': index, 'verbose': true})
        .map((move) => move['to'].toString())
        .toList();
  }

  @override
  void tapTile(String index) {
    if (!args.isMultiplayer && args.asBlack == (turn() == PieceColor.WHITE)) {
      return;
    }
    if (index == selectedTile) {
      select(null);
    } else if (selectedTile != null) {
      if (chess.get(index)?.color == chess.turn) {
        select(index);
      } else {
        makeMove(selectedTile!, index);
        select(null);
      }
    } else if (chess.get(index)?.color == chess.turn) {
      select(index);
    } else {
      return;
    }

    notifyListeners();
  }

  @override
  void clear() {
    chess.reset();
    selectedTile = null;
    availableMoves = [];
    eatenBlack = [];
    eatenWhite = [];
    promotionMove = null;
    previousMove = null;
    notifyListeners();
  }
  @override
  void start() {
    chess.reset();
    chessHistory.clear();
    chessHistory.add(chess.fen);
    chessRedoStack.clear();
    _player1Timer.reset();
    _player2Timer.reset();
   // _startTimerForCurrentPlayer();
    maybeCallAI();
    notifyListeners();
  }
  @override
  Game save() {
    if (saveCurrentGame) {
      String name = DateTime.now().toString().substring(0, 16) +
          (args.isMultiplayer ? " Multiplayer" : " vs ${args.difficultyOfAI}");
      final id = Localstore.instance.collection("games").doc().id;
      Game game = Game(
        id: id,
        name: name,
        fen: chess.fen,
        args: args,
        eatenBlack: eatenBlack,
        eatenWhite: eatenWhite,
      );
      game.save();
      saveCurrentGame = false; // Reset the flag after saving
      chessHistory.clear(); // Clear the history after saving
      chessHistory.add(chess.fen); // Save the initial state to history
      chessRedoStack.clear(); // Clear redo stack after saving
      return game;
    }
    return Game(id: "", name: "", fen: "", args: GameArguments(), eatenBlack: [], eatenWhite: []);
  }
  @override
  void load(Game game) {
    clear();
    chess = chess_lib.Chess.fromFEN(game.fen);
    args = game.args;
    eatenBlack = game.eatenBlack;
    eatenBlack = game.eatenWhite;
    notifyListeners();
    maybeCallAI();
  }
}
