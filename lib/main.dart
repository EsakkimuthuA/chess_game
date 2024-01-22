
import 'package:chess_game/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'engine/choose_color_screen.dart';
import 'engine/choose_difficulty_screen.dart';
import 'engine/game_logic.dart';
import 'engine/game_screen.dart';
import 'engine/resume_screen.dart';
import 'engine/timer.dart';
import 'firebase_options.dart';
const kWebRecaptchaSiteKey = "AIzaSyBYsklEXh8FvrcDuxX1c6GzwKz3SmSZuo4";
    //'AIzaSyAlQloKdaZyZ07q653fAWogE1swGdohGzA';
void main() async{

  GetIt.instance.registerSingleton<GameLogic>(GameLogicImplementation(), signalsReady: true);

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

 //  WidgetsFlutterBinding.ensureInitialized();
 //  await Firebase.initializeApp(
 //    options: DefaultFirebaseOptions.currentPlatform,
 //  );
 // //
 //  await FirebaseAppCheck.instance.activate(
 //    // Your personal reCaptcha public key goes here:
 //
 //    androidProvider: AndroidProvider.debug,
 //    appleProvider: AppleProvider.debug,
 //    webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
 //  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
  runApp( MyApp(),
    // ChangeNotifierProvider(
    //   create: (context) => AppModel(),
    //   child: MyApp(),
    // ),
  );
//  _loadFlameAssets();
}
//
// void _loadFlameAssets() async {
//   List<String> pieceImages = [];
//   for (var theme in PIECE_THEMES) {
//     for (var color in ['black', 'white']) {
//       for (var piece in ['king', 'queen', 'rook', 'bishop', 'knight', 'pawn']) {
//         pieceImages
//             .add('pieces/${formatPieceTheme(theme)}/${piece}_$color.png');
//       }
//     }
//   }
//   await Flame.images.loadAll(pieceImages);
// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // static FirebaseAnalyticsObserver observer =
  // FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //  GetIt.instance.registerSingleton<GameLogic>(GameLogicImplementation(), signalsReady: true);
    return  GestureDetector(
        onTap: ()=>FocusManager.instance.primaryFocus?.unfocus(),
       child:GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
           // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrangeAccent),
    //     useMaterial3: true,
        ),
         home: const Splashscreen(),
           //  initialRoute: '/',
             routes: {
              // '/': (context) => const HomeScreen2(),
               '/difficulty': (context) => const ChooseDifficultyScreen(),
               '/color': (context) => const ChooseColorScreen(),
               '/resume': (context) => const ResumeScreen(),
               '/game': (context) => const GameScreen(),
               "/clock":(context)=>  const ClockWidget(),
             }
        // routes: {
        // "/Play Local":(context)=>PlayLocal(),
        // "/Tournament":(context)=>TournamentPage(),
        // "/Play with Friends":(context)=>PlayFriend(),
        // "/Play Online":(context)=>PlayOnline(),
        // "/Easy":(context)=>PlayFriend(),
        // "/Medium":(context)=>PlayOnline(),
        // "/Hard":(context)=>PlayFriend(),
        //"/mobiles": (context)=>MobilesPage(),
       // "/laptops": (context)=>LaptopsPage(),
    //  },
       )
    );
  }
}




