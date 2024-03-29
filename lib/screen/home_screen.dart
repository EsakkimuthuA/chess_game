
import 'package:chess_game/screen/Event_screen.dart';
import 'package:chess_game/screen/homepage.dart';
import 'package:chess_game/screen/shop-screen.dart';
import 'package:chess_game/screen/watch_screen.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:chess_game/colors.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../gift_page.dart';
import '../user/current_user.dart';
class RewardAmountProvider extends ChangeNotifier {
  int _totalRewardAmount = 100;

  int get totalRewardAmount => _totalRewardAmount;

  void updateRewardAmount(int amount) {
    _totalRewardAmount += amount;
    notifyListeners();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.labelText});
  final String? labelText;
  // static List<Widget> screens = [
  //  Homepage(),
  //  Event(),
  //  Watch(),
  //  Shop(),
  // ];
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int newIndex = 0;
  Widget? _child;
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());//

  @override
  void initState() {
    super.initState();
    _child = ChangeNotifierProvider(
      create: (context) => RewardAmountProvider(),
      child: Homepage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(                  //
        init: CurrentUser(),              //
        initState: (currentState){              //
          _rememberCurrentUser.getUserInfo();   //
        },
        builder: (controller) {
          // PageWrapper(
          //   child:
          return  Scaffold(
                 extendBody: true,
                 body: _child,
                 bottomNavigationBar: FluidNavBar(
                 icons: [
                  FluidNavBarIcon(
                    // svgPath: "assets/arrow-back.png",
                    icon: Icons.home,
                    //  backgroundColor: Color(0xFF4285F4),
                    extras: {"label": "Home"},
                  ),
            
                  FluidNavBarIcon(
                      icon: Icons.zoom_in,
                      // backgroundColor:Color(0xFF4285F4),
                      extras: {"label": "Friends"}),
                  FluidNavBarIcon(
                      icon: Icons.emoji_events,
                      // backgroundColor: Color(0xFF4285F4),
                      extras: {"label": "Events"}),
                  FluidNavBarIcon(
                    // svgPath: "assets/conference.svg",
                      icon: Icons.shopping_cart,
                      //backgroundColor: Color(0xFF4285F4),
                      extras: {"label": "Shop"}),
                ],
                   onChange: _handleNavigationChange,
                   style: const FluidNavBarStyle(
                     iconUnselectedForegroundColor: Colors.white,
                     iconSelectedForegroundColor: Colors.orangeAccent,
                     barBackgroundColor: color.navy1,
                   ),
                   animationFactor: 1,
                   scaleFactor: 1.5,
                   defaultIndex: 0,
                   itemBuilder: (icon, item) => Semantics(label: icon.extras!["label"],
                     child: item,
                   ),
              ),
              //  ),
               // ),
          );
        });
  }
  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child =  ChangeNotifierProvider(
            create: (context) => RewardAmountProvider(),
            child: Homepage(),
          );
          break;
        case 1:
          _child =  Watch();
          break;
        case 2:
          _child =  Event();
          break;
        case 3:
          _child =  Shop();
          break;
      }
      // _child = AnimatedSwitcher(
      //  switchInCurve: Curves.easeOut,
      //  switchOutCurve: Curves.easeIn,
      //   duration: Duration(milliseconds: 10000),
      //   child: _child,
      // );
    });
  }
  //         bottomNavigationBar: BottomNavyBar(
  //         backgroundColor: Colors.transparent,
  //         itemCornerRadius: 10,
  //         selectedIndex: newIndex,
  //         items: AppData.bottomNavyBarItems
  //             .map(
  //               (item) => BottomNavyBarItem(
  //             icon: item.icon,
  //             activeColor:Color(0xFFEC6813),
  //             inactiveColor:Color(0xFF040D36),
  //             title: Text(item.title,style: TextStyle(color: Color(0xFF040D36)),),
  //           ),
  //         )
  //             .toList(),
  //         onItemSelected: (currentIndex) {
  //           newIndex = currentIndex;
  //           setState(() {});
  //         },
  //       ),
  //       body: HomeScreen.screens[newIndex],
  //       Container(
  //       height: screenHeight/1,
  //        width: screenWidth/1,
  //        decoration: BoxDecoration(
  //       image: DecorationImage(
  //        image: AssetImage('assets/Home-page.png'),
  //       fit: BoxFit.cover
  //       )
  //       ),
  //       child:
  //       PageTransitionSwitcher(
  //         duration: const Duration(seconds: 0),
  //         transitionBuilder: (
  //             Widget child,
  //             Animation<double> animation,
  //             Animation<double> secondaryAnimation,
  //             ) {
  //           return FadeThroughTransition(
  //             animation: animation,
  //             secondaryAnimation: secondaryAnimation,
  //             child: child,
  //           );
  //         },
  //         child: HomeScreen.screens[newIndex],
  //       ),
  //    ),
  //      )
  //  );
  // }
}

//
// class PageWrapper extends StatelessWidget {
//   final Widget child;
//   const PageWrapper({Key? key, required this.child}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 800), child: child),
//     );
//   }
// }
