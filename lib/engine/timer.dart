
import 'package:chess_game/colors.dart';
import 'package:flutter/material.dart';
import 'game_logic.dart';

class TimerOptionPage extends StatefulWidget {
  const TimerOptionPage({super.key});

  @override
  _TimerOptionPageState createState() => _TimerOptionPageState();
}

class _TimerOptionPageState extends State<TimerOptionPage> {
  int selectedTime = 1; // Initial value, you can change it as needed

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth =MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: color.navy1,
      appBar: AppBar(
        title: Text('Select Timer',style: TextStyle(color: Colors.white),),
        backgroundColor: color.navy1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected Time: $selectedTime minutes',
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
            SizedBox(height: screenHeight/20,),
            Slider(
              value: selectedTime.toDouble(),
              min: 1,
              max: 60,
              inactiveColor: Colors.orange,
              activeColor: Colors.purple,
              divisions: 59,
              onChanged: (value) {
                setState(() {
                  selectedTime = value.toInt();
                  logic.updateTimers(Duration(minutes: selectedTime));
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(right: screenWidth/40,left: screenWidth/40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0'  ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                  Text('60',  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedTime);
                logic.args.isMultiplayer = true;
                Navigator.pushNamed(context, '/color');
              },
              child: Text('Start Game',),
            ),
            Padding(
              padding: EdgeInsets.only(right: screenWidth/40,left: screenWidth/40),
              child: Text("if you don't want a time limit option click the button below: ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedTime);
                logic.args.isMultiplayer = true;
                Navigator.pushNamed(context, '/color2');
              },
              child: Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
