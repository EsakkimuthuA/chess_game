import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cyber_punk_tool_kit_ui/cyber_punk_tool_kit_ui.dart';
import 'package:flutter/material.dart';
import 'package:chess_game/colors.dart';
import 'package:get_it/get_it.dart'; 
import '../buttons/back_button.dart';
import 'game_logic.dart';
final logic = GetIt.instance<GameLogic>();
class ChooseDifficultyScreen extends StatelessWidget {
  const ChooseDifficultyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const difficulties = [
      //"Kid"
       "Easy", "Normal", "Hard",
      //"Unreal"
    ];
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: color.navy1,
        body: Column(
          children: [
            SizedBox(height: screenHeight/20,),
            ArrowBackButton2(color: Colors.white,),
            SizedBox(height: screenHeight/20,),
            for (final difficulty in difficulties)
              Column(
                children: [
                  CyberButton(
                      width: screenWidth/2,
                      height: screenHeight/15,
                      primaryColorBigContainer: color.navy,
                      secondaryColorBigContainer: Colors.purple,
                      primaryColorSmallContainer: Colors.black,
                      secondaryColorSmallContainer: Colors.transparent,
                              //TextButton(
                       onTap: () {
                        logic.args.difficultyOfAI = difficulty;
                        Navigator.pushNamed(context, '/color');
                      },
                  // style: ButtonStyle(
                  //   fixedSize: MaterialStateProperty.all<Size>(
                  //     Size(screenWidth / 2, screenHeight / 15), // Set your desired width and height
                  //   ),
                  // ),
                      child: Text(difficulty, textScaleFactor: 2.0,style: TextStyle(color: Colors.white),),
                    ),
                  SizedBox(height: 8),
                ],
              ),
          ]
        )
    );  
  }
}
class ChooseDifficultyScreen2 extends StatefulWidget {
  const ChooseDifficultyScreen2({Key? key}) : super(key: key);

  @override
  State<ChooseDifficultyScreen2> createState() => _ChooseDifficultyScreen2State();
}

class _ChooseDifficultyScreen2State extends State<ChooseDifficultyScreen2> {
  double _scaleFactor = 1.0;
  @override
  Widget build(BuildContext context) {
    const difficulties = [
      //"Kid"
      "Easy", "Normal", "Hard",
      //"Unreal"
    ];
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: color.navy1,
        body: Column(
            children: [
              SizedBox(height: screenHeight/20,),
              ArrowBackButton2(color: Colors.white,),
              SizedBox(height: screenHeight/15,),
              for (final difficulty in difficulties)
                Column(
                  children: [
                    BouncingWidget(
                      scaleFactor: _scaleFactor,
                      onPressed: () => Navigator.pushNamed(context, '/color2'),
                    child: CyberButton(
                      width: screenWidth/2,
                      height: screenHeight/15,
                      primaryColorBigContainer: color.navy,
                      secondaryColorBigContainer: Colors.purple,
                      primaryColorSmallContainer: Colors.black,
                      secondaryColorSmallContainer: Colors.transparent,
                      //TextButton(
                      onTap: () {
                        logic.args.difficultyOfAI = difficulty;
                        Navigator.pushNamed(context, '/color2');
                      },
                      // style: ButtonStyle(
                      //   fixedSize: MaterialStateProperty.all<Size>(
                      //     Size(screenWidth / 2, screenHeight / 15), // Set your desired width and height
                      //   ),
                      // ),
                      child: Text(difficulty, textScaleFactor: 2.0,style: TextStyle(color: Colors.white),),
                    ) ),
                    SizedBox(height:screenHeight/ 20),
                  ],
                 ),
            ]
        )
    );
  }
}
