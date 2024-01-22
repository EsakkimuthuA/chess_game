import 'package:chess_game/colors.dart';
import 'package:chess_game/engine/timer.dart';
import 'package:flutter/material.dart';
import '../expandable-slider.dart';
import 'piece_widget.dart';

import 'package:get_it/get_it.dart'; 
import 'game_logic.dart'; 
final logic = GetIt.instance<GameLogic>(); 

class ChooseColorScreen extends StatelessWidget {
  const ChooseColorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.navy1,
      // appBar: AppBar(
      //   title: const Text("You Play As"),
      // ),
      body:
      // Column(
      //       children: [
      //         SizedBox(height: 200,),
      //         ExpandSlider(max: 120, min: 0,),
      //         ExpandSlider(max: 60, min: 0,name: 'Bonce ',time: ' sec',value: ' 60',),
      //         SizedBox(height: 50,),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                        child: SizedBox(
                          width: 120, height: 120,
                          child: PieceWidget(piece: Piece(PieceType.KING, PieceColor.BLACK))
                        ),
                        onTap: () {
                         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TimerOption()));
                           logic.args.asBlack = true;
                          Navigator.pushNamed(context, '/game');
                          logic.start();
                        }
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                        child: SizedBox(
                          width: 120, height: 120,
                          child: PieceWidget(piece: Piece(PieceType.KING, PieceColor.WHITE))
                        ),
                        onTap: () {
                          logic.args.asBlack = false;
                          Navigator.pushNamed(context, '/game');
                          logic.start();
                        }
                      ),
                    ),
                  ]
                ),
              ),

          //   ],
          // )
    );
  }
}


class TimerOption extends StatefulWidget {
  const TimerOption({super.key});

  @override
  State<TimerOption> createState() => _TimerOptionState();
}

class _TimerOptionState extends State<TimerOption> {
  int selectedTime = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.navy1,
      body: Column(
        children: [
          SizedBox(height: 100,),
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
            // onTap: (){
            //   logic.args.asBlack = true;
            //   Navigator.pushNamed(context, '/game');
            //   logic.start();
            // },
            dropdownColor: Colors.blue,
            iconEnabledColor: Colors.blue,
            items: [0,5, 10, 15, 20, 30].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: GestureDetector(
                    onTap: (){
                      logic.args.isMultiplayer = true;
                      Navigator.pushNamed(context, '/color');
                    },
                    child: Text('$value minutes',style: TextStyle(color: Colors.white),)),

              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
