import 'dart:async';
import 'package:chess_game/login/sign_in.dart';
import 'package:chess_game/login/sign_up.dart';
import 'package:chess_game/screen/home_screen.dart';
import 'package:chess_game/screen/homepage.dart';
import 'package:chess_game/user/user_preference.dart';
import 'package:flutter/material.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen( {super.key});
  @override
  State<Splashscreen> createState() => _SplashscreenState();
}
class _SplashscreenState extends State<Splashscreen> {
  //late GlobalKey<NavigatorState> navigatorKey;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
   // navigatorKey = GlobalKey<NavigatorState>();
    _timer = Timer(const Duration(milliseconds: 4000), () async{
      if (mounted) {

        final userPrefs = await RememberUserPrefs.readUserInfo();
        Widget initialRoute;
        if (userPrefs == null) {
          initialRoute = const SignIn();
        } else {
          initialRoute = const HomeScreen();
        }
       // navigatorKey.currentState?
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => initialRoute));

        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => const HomeScreen(),
        //   ),
        // );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return
    //  Navigator(
        // key: navigatorKey,
        // onGenerateRoute: (_) {
        //   return MaterialPageRoute(
        //       builder: (context) =>
                  Scaffold(
                body: Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height/1,
                    width: MediaQuery.of(context).size.width/1,
                    child: Image.asset('assets/splash-page.gif', fit: BoxFit.cover,),
                  ),
                ),
              );
        //   );
        // });
  }
}