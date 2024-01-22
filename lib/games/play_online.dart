import 'package:carousel_slider/carousel_slider.dart';
import 'package:chess_game/buttons/back_button.dart';
import 'package:chess_game/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> clipbordExample() async{
  ClipboardData? data =await Clipboard.getData('text/plain');
  String?text = data?.text;
  const helloMsg = ClipboardData(text: "hello flutter");
  await Clipboard.setData(helloMsg);
  bool hasText = await Clipboard.hasStrings();
}
class User1 {
  final String username;
  final String place;
  final String points;

  const User1( {
    required this.place,
    required this.username,
    required this.points,});
}


class PlayOnline extends StatefulWidget {
  const PlayOnline({super.key});

  @override
  State<PlayOnline> createState() => _PlayOnlineState();
}

class _PlayOnlineState extends State<PlayOnline>with TickerProviderStateMixin {
  int activeIndex = 0;
  CarouselController buttonCarouselController = CarouselController();

  final _items = [
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.pink,
  ];
  final _pageController = PageController();
  final _pageController2 = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _currentPageNotifier2 = ValueNotifier<int>(0);
  final _boxHeight = 150.0;


  List<User1> users=[
    const User1(username: '100 Coins', place: 'winning amount: 170',points: 'assets/pawn.png'),
    const User1(username: '200 Coins', place: 'winning amount: 340',points:  'assets/bishop.png'),
    const User1(username: '500 Coins', place: 'winning amount: 850',points:  'assets/knight1.png'),
    const User1(username: '1000 Coins', place: 'winning amount: 1700',points:  'assets/rook1.png'),
    const User1(username: '2000 Coins', place: 'winning amount: 3400',points:  'assets/queen.png'),
    const User1(username: '5000 Coins', place: 'winning amount: 4250',points:  'assets/piece.png'),
  ];
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: color.navy1,
          automaticallyImplyLeading: false,
          leading: ArrowBackButton(color: Colors.white,),
          title: Padding(
            padding:  EdgeInsets.only(right: screenWidth/10),
            child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('PLAY ',style: GoogleFonts.oswald(color: Colors.white,fontSize: screenWidth/20,fontWeight: FontWeight.bold),
                        ),
                        Text('ONLINE',style: GoogleFonts.oswald(fontSize: screenWidth/20,fontWeight: FontWeight.bold,color: Colors.amberAccent),),
                      ],
                    ),
                    Padding(
                      padding:EdgeInsets.symmetric(horizontal:10.0),
                      child:Container(
                        height:screenHeight/400,
                        width:screenWidth/5,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white,Colors.amber, Colors.white],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                      ),),
                  ],
                ),
          ),
        ),
        body: Container(
          height: screenHeight/1,
          width: screenWidth/1,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/checked-background.png'), fit: BoxFit.cover,

            ),),
          child: Container(
            height: screenHeight/1,
            width: screenWidth/1,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/play-online2.png'), fit: BoxFit.cover,

              ),),
            // child: SingleChildScrollView(
            //   scrollDirection: Axis.vertical,
              child: Column(
               children: [
                 SizedBox(height: screenHeight/10,),
              Padding(
                padding: const EdgeInsets.only(right: 4.0,left: 4.0),
                child: Stack(
                    alignment: Alignment.bottomCenter,
                    children:[
                      CarouselSlider(
                      //  items: _items.map((itemColor)
                  items: users.map((user) {
                    // final user = users[index];
                    List<Gradient> containerGradients = [
                      RadialGradient(
                        colors: [Colors.red, Colors.brown,Colors.red],
                        radius: 1.75,
                      ),
                      LinearGradient(
                        colors: [Colors.blue,Colors.green, Colors.blue],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      LinearGradient(
                        colors: [Colors.orange, Colors.pink,Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      RadialGradient(
                        colors: [Colors.blue, Colors.purple],
                        radius: 2.75,
                      ),
                      // Add more gradients as needed
                    ];
                    Gradient containerGradient = containerGradients[users.indexOf(user) % containerGradients.length];
                          return Container(
                            height: screenHeight/2.5,
                            width: screenWidth/1.3,
                            decoration: BoxDecoration(
                             // color: itemColor,
                              gradient: containerGradient,
                             //  gradient: LinearGradient(
                             //    colors: [Colors.brown, Colors.red, Colors.brown], // Adjust the gradient colors as needed
                             //    begin: Alignment.bottomLeft,
                             //    end: Alignment.topRight,
                             //  ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: color.navy.withOpacity(0.55), width: 10.0
                                //   bottom: BorderSide(color: color.navy1, width: 3.0), // Set the border color and width for the bottom side
                              ),
                            ),
                          //  child: Text('100 coins'),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    user.username,
                                    style: GoogleFonts.oswald(
                                      color: Colors.white,
                                      fontSize: screenWidth / 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user.place,
                                    style: TextStyle(fontSize: 13, color: Colors.white),
                                  ),
                                  SizedBox(height: 10),
                                  Image(
                                    image: AssetImage(user.points),
                                    height: screenHeight / 10,
                                    width: screenWidth / 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      // CarouselSlider(
                      //   items: [
                      //     GestureDetector(
                      //       child: Container(
                      //         // height: screenHeight/4,
                      //         // width:screenWidth/1,
                      //         decoration: BoxDecoration(
                      //           color: color.green,
                      //         ),
                      //       ),
                      //       onTap:(){},
                      //     ),
                      //
                      //   ],
                        carouselController: buttonCarouselController,
                        options:  CarouselOptions( // Set the desired options for the carousel
                          onPageChanged: (index, reason){
                            setState((){
                            //  activeIndex=index;
                            });
                          },
                          initialPage: 0,
                          // height: 300, // Set the height of the carousel
                          enlargeCenterPage: true,
                        //  autoPlay: true, // Enable auto-play
                          autoPlayCurve: Curves.easeInOut, // Set the auto-play curve
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: Duration(milliseconds: 300), // Set the auto-play animation duration
                          aspectRatio: 16/9, // Set the aspect ratio of each item
                          viewportFraction: 0.8, // You can also customize other options such as enlargeCenterPage, enableInfiniteScroll, etc.
                        ),
                      ),
                      Positioned(
                        bottom: 80,
                        right: 0,
                        left: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             GestureDetector(
                                onTap: ()=> buttonCarouselController.previousPage(
                                    duration: Duration(milliseconds: 300), curve: Curves.linear),
                                  child: Image(
                                    image: AssetImage('assets/arrowb1.png'),
                                    height: screenHeight/20,width: screenWidth/15,color: Colors.orange,)),
                           GestureDetector(
                                  onTap: () => buttonCarouselController.nextPage(
                                      duration: Duration(milliseconds: 300), curve: Curves.linear),
                                  child: Image(
                                    image: AssetImage('assets/arrowf1.png'),
                                    height: screenHeight/20,width: screenWidth/15,color: Colors.orange,)),
                          ],
                        ),
                      ),
                      // Padding(padding: EdgeInsets.all(10.0),
                      //   child: AnimatedSmoothIndicator(
                      //     activeIndex: activeIndex,
                      //     count: 4,
                      //     effect: WormEffect(
                      //         dotHeight: 10,dotWidth: 10,
                      //         activeDotColor: Colors.blue,
                      //         dotColor: Colors.grey
                      //     ),
                      //   ),
                      // )
                    ]
                ),
              ),
                 // Container(
                 //   height: screenHeight/1.7,
                 //   width: screenWidth/1.5,
                 //   // decoration: BoxDecoration(
                 //   //     borderRadius: BorderRadius.circular(12)
                 //   // ),
                 //   child:
                 //   ListView.separated(
                 //     physics: AlwaysScrollableScrollPhysics(),
                 //     itemCount: users.length,
                 //     separatorBuilder: (BuildContext context, int index) {
                 //       // Add space between items using a SizedBox
                 //       return SizedBox(height: screenHeight/20); // Adjust the height as needed
                 //     },
                 //     itemBuilder: (BuildContext context, int index) {
                 //       final user = users[index];
                 //
                 //       List<Gradient> containerGradients = [
                 //         RadialGradient(
                 //           colors: [Colors.red, Colors.brown],
                 //           radius: 1.75,
                 //         ),
                 //         LinearGradient(
                 //           colors: [Colors.blue,Colors.green, Colors.blue],
                 //           begin: Alignment.centerLeft,
                 //           end: Alignment.centerRight,
                 //         ),
                 //         LinearGradient(
                 //           colors: [Colors.orange, Colors.pink,Colors.orange],
                 //           begin: Alignment.topLeft,
                 //           end: Alignment.bottomRight,
                 //         ),
                 //         RadialGradient(
                 //           colors: [Colors.blue, Colors.purple],
                 //           radius: 2.75,
                 //         ),
                 //         // Add more gradients as needed
                 //       ];
                 //       Gradient containerGradient = containerGradients[index % containerGradients.length];
                 //       // List<Color> containerColors = [
                 //       //   Colors.blue,
                 //       //   Colors.green,
                 //       //   Colors.orange,
                 //       //   Colors.purple// Add more colors as needed
                 //       // ];
                 //       // // Get the color based on the index (you may want to adjust this based on your requirements)
                 //       // Color containerColor = containerColors[index % containerColors.length];
                 //
                 //       return Container(
                 //           height: screenHeight/10,
                 //           width: screenWidth/1.5,
                 //           decoration: BoxDecoration(
                 //             gradient: containerGradient,
                 //             // gradient:  RadialGradient(
                 //             //   colors: [Colors.red, Colors.yellow],
                 //             //   radius: 0.75,
                 //             // ),
                 //          //   color: containerColor,
                 //             borderRadius: BorderRadius.circular(10),
                 //             border: Border.all(
                 //                 color: color.navy.withOpacity(0.55), width: 10.0
                 //            //   bottom: BorderSide(color: color.navy1, width: 3.0), // Set the border color and width for the bottom side
                 //             ),
                 //           ),
                 //               child: Padding(
                 //                 padding: EdgeInsets.only(left: screenWidth/20,right: screenWidth/20),
                 //                     child: Row(
                 //                       children: [
                 //                         Column(
                 //                           mainAxisAlignment: MainAxisAlignment.center,
                 //                           children: [
                 //                             Text(user.username,style: GoogleFonts.oswald(color: Colors.white,fontSize: screenWidth/20,fontWeight: FontWeight.bold),),
                 //                              Text(user.place,style: TextStyle(fontSize: 13,color: Colors.white),),
                 //                           ],
                 //                         ),
                 //                         SizedBox(width: screenWidth/20,),
                 //                         Image(image:AssetImage( user.points,),height: screenHeight/10,width: screenWidth/10,),
                 //                       ],
                 //                     ),
                 //               ),
                 //       );
                 //     },
                 //   ),
                 // ),
                 SizedBox(height: 100,),
                 TweenAnimationBuilder(
                     tween: Tween<double>(begin:0,end:1),
                     duration: const Duration(milliseconds: 3000),
                     builder: (context,double value,child){
                       return Opacity(opacity: value,
                       child:  MaterialButton(
                         onPressed: (){},
                           height: 50,
                           minWidth: 100,
                           color: Colors.red,
                           child: Text("Hello flutter")),);
                 })
               ],
         ),
          //  ),
          ),
     )
    );
  }
}








//
// class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
//   Color baseColor = Color(0xFFf2f2f2);
//   double firstDepth = 50;
//   double secondDepth = 50;
//   double thirdDepth = 50;
//   double fourthDepth = 50;
//   late AnimationController _animationController;
//
//   @override
//   void initState() {
//     _animationController = AnimationController(
//       vsync: this, // the SingleTickerProviderStateMixin
//       duration: Duration(seconds: 5),
//     )..addListener(() {
//       setState(() {});
//     });
//
//     _animationController.forward();
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double? stagger(value, progress, delay) {
//       progress = progress - (1 - delay);
//       if (progress < 0) progress = 0;
//       return value * (progress / delay);
//     }
//
//     double calculatedFirstDepth =
//     stagger(firstDepth, _animationController.value, 0.25)!;
//     double calculatedSecondDepth =
//     stagger(secondDepth, _animationController.value, 0.5)!;
//     double calculatedThirdDepth =
//     stagger(thirdDepth, _animationController.value, 0.75)!;
//     double calculatedFourthDepth =
//     stagger(fourthDepth, _animationController.value, 1)!;
//
//     return Container(
//       color: baseColor,
//       child: Center(
//         child: Container(
//           height: 400,
//           width: 360,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: Colors.red, // Set your desired border color
//               width: 5.0, // Set your desired border width
//             ),
//           ),
//           child: ClayContainer(
//             color: baseColor,
//             height: 340,
//             width: 340,
//             borderRadius: 20,
//             // emboss: true,
//             curveType: CurveType.concave,
//             spread: 30,
//             depth: calculatedFirstDepth.toInt(),
//             child: Center(
//               child: ClayContainer(
//                 height: 150,
//                 width: 150,
//                 //emboss: true,
//                 borderRadius: 20,
//                 depth: calculatedSecondDepth.toInt(),
//                 curveType: CurveType.convex,
//                 //color: baseColor,
//                 child: Directionality(
//                     textDirection: TextDirection.ltr,
//                     child: Column(
//                       children: [
//                         Stack(
//                           children: [
//                             Image(image: AssetImage('assets/chessboard1.png'),height: 140,width: 140,),
//                             // Center(child: Text('100 Coins',style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),))
//                             //Text('hollow',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.purple,fontSize: 20),),
//                           ],
//                         ),
//                         SizedBox(height: 20,),
//                         ClayContainer(
//                           color: Colors.brown,
//                           height: 80,
//                           width: 300,
//                           emboss: true,
//                           borderRadius: 20,
//                           depth: calculatedSecondDepth.toInt(),
//                           curveType: CurveType.convex,
//                         )
//                       ],
//                     )),
//                 // Center(
//                 //   child: ClayContainer(
//                 //       height: 160,
//                 //       width: 160,
//                 //       borderRadius: 20,
//                 //       color: baseColor,
//                 //       depth: calculatedThirdDepth.toInt(),
//                 //       curveType: CurveType.concave,
//                 //       child: Center(
//                 //           child: ClayContainer(
//                 //             height: 120,
//                 //             width: 120,
//                 //             borderRadius: 20,
//                 //             color: baseColor,
//                 //             depth: calculatedFourthDepth.toInt(),
//                 //             curveType: CurveType.convex,
//                 //           ))),
//                 // ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }