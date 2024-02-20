
import 'package:admob_flutter/admob_flutter.dart';
import 'package:chess_game/profile_page.dart';
import 'package:chess_game/screen/home_screen.dart';
import 'package:chess_game/setting_page.dart';
import 'package:chess_game/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'engine/choose_color_screen.dart';
import 'engine/choose_color_screen2.dart';
import 'engine/choose_difficulty_screen.dart';
import 'engine/game_logic.dart';
import 'engine/game_screen.dart';
import 'engine/game_screen2.dart';
import 'engine/resume_screen.dart';
import 'package:camera/camera.dart';

import 'gift_page.dart';

const kWebRecaptchaSiteKey = "AIzaSyBYsklEXh8FvrcDuxX1c6GzwKz3SmSZuo4";
    //'AIzaSyAlQloKdaZyZ07q653fAWogE1swGdohGzA';
List<CameraDescription> cameras = [];
Future<void> main() async {

 // GetIt.instance.registerSingleton<GameLogic>(GameLogicImplementation(), signalsReady: true);

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  Admob.initialize();
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

  runApp(
    //MyApp(),
    ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: MyApp(),
    ),
  );
//  _loadFlameAssets();
}

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
        child: ChangeNotifierProvider(
        create: (_) => RewardAmountProvider(),
        child: ChangeNotifierProvider(
        create: (context) => ProfileProvider(),

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
              // // '/': (context) => const HomeScreen2(),
              //  '/difficulty': (context) => const ChooseDifficultyScreen(),
              //  '/color': (context) => const ChooseColorScreen(),
              //  '/resume': (context) => const ResumeScreen(),
              //  '/game': (context) => const GameScreen(),
              //  '/color2': (context) => const ChooseColorScreen2(),
              //  '/game2': (context) => const GameScreen2(),
              //  '/difficulty2': (context) => const ChooseDifficultyScreen2(),
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
        ) ))
    );
  }
}




