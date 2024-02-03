
import 'dart:convert';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:chess_game/cyber/cyber_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colors_border/flutter_colors_border.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chess_game/colors.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../gift_page.dart';
import '../profile_page.dart';
import '../setting_page.dart';
import '../user/current_user.dart';
import 'package:http/http.dart' as http;


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin{
  final _key = GlobalKey<ScaffoldState>();
  double _scaleFactor = 1.0;
  final CurrentUser _currentUser = Get.find<CurrentUser>();
  late Map<String, dynamic> userData = {};

  Future<void> fetchChequeImages() async {
    var url = Uri.parse('https://leadproduct.000webhostapp.com/chessApi/fetch_profile_picture.php'); // Update with your API endpoint
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      List<dynamic> result = jsonDecode(response.body);
      print(result); // Output the fetched data
    } else if (response.statusCode == 404) {
      print('No Images found');
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load cheque images');
    }
  }


  @override
  void initState() {
    super.initState();
  }
  _onPressed(BuildContext context) {
    print("CLICK");
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return
      // Scaffold(
      //
      // body:
      Container(
        height: screenHeight/1,
        width: screenWidth/1,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/chess1.png'),
                fit: BoxFit.cover
            )
        ),
        child: SingleChildScrollView(
         //physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          //BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
           physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Gap(screenHeight/18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
                   },
                   child: FlutterColorsBorder(
                        available: true,
                        size: Size(screenWidth/8,screenHeight/18),
                        boardRadius: 5,
                      child:Container(
                        height: 50,
                        width: 50,
                        child:
                        Consumer<ProfileProvider>(
                          builder: (context, profileProvider, _) {
                            if (profileProvider.profilePicturePath == null) {
                              return FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder_image.png',
                                image: 'https://leadproduct.000webhostapp.com/chessApi/cheque/profile_image_${userData['user_id'] ?? ''}.jpg',
                                fit: BoxFit.cover,
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image(image: AssetImage('assets/placeholder_image.png'));
                                },
                              );
                            } else {
                              return Image(image: AssetImage('assets/placeholder_image.png'));
                            }
                          },
                        )
                      ),
                      // Obx(
                      //  () => CircleAvatar(
                      //         radius: 50.0,
                      //         backgroundImage: NetworkImage('https://leadproduct.000webhostapp.com/chessApi/cheque/profile_image_${_currentUser.getCurrentUserId()}.jpg'),
                      //       )
        //               //  ),
        //               Consumer<ProfileProvider>(
        //                 builder: (context, profileProvider, _) => profileProvider.profilePicturePath != null
        //                     ?Text('No image selected.')
        //                 // Obx(
        //                 //         () => CircleAvatar(
        //                 //       radius: 50.0,
        //                 //       backgroundImage: NetworkImage('https://leadproduct.000webhostapp.com/chessApi/cheque/profile_image_${_currentUser.getCurrentUserId()}.jpg'),
        //                 //     )
        //                 // )
        //                     : Obx(
        //                      () => CircleAvatar(
        //              radius: 50.0,
        //              backgroundImage: NetworkImage('https://leadproduct.000webhostapp.com/chessApi/cheque/profile_image_${_currentUser.getCurrentUserId()}.jpg'),
        //            )
        // ),
        //               ),
        //                    Center(
        //                       child: Icon(Icons.person,color: Colors.white,size: 50,)
        //                       //Image(image: AssetImage('assets/profile.png'),),
        //                     ),
                        ),
                 ),
                 // Icon(Icons.mail,color: Colors.grey,),
                  Container(
                    height: screenHeight/32,
                    width: screenWidth/4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: color.navy
                    ),
                    child: Row(
                      children: [
                        Image(image: AssetImage('assets/money1.png'),
                          height: screenHeight/20,
                          width: screenWidth/16,
                        ),
                        Container(
                            height: screenHeight/32,
                            width: screenWidth/7,
                            child: Center(
                                child: Text("0",style: TextStyle(color: Colors.white),))),
                        //Gap(screenWidth/10),
                        // Padding(
                        //   padding:  EdgeInsets.only(left: screenWidth/7.5),
                          Image(image: AssetImage('assets/plus1.png'),
                            height: screenHeight/28,
                            width: screenWidth/23,
                          ),
                        //),
                      ],
                    ),
                  ),
                  Container(
                    height: screenHeight/32,
                    width: screenWidth/4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: color.navy
                    ),
                    child: Row(
                      children: [
                        Image(image: AssetImage('assets/Dollar.png'),
                          height: screenHeight/25,
                          width: screenWidth/18,
                        ),
                        Container(
                            height: screenHeight/32,
                            width: screenWidth/7.5,
                            child: Center(
                                child: Text("100",style: TextStyle(color: Colors.white),))),
                       Image(image: AssetImage('assets/plus1.png'),
                         height: screenHeight/28,
                         width: screenWidth/23,
                          ),
                      ],
                    ),
                    //  ),
                  ),
                  IconButton(onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingPage()));

                  }, icon: Icon(Icons.settings,color: Colors.grey,)),
                ],
              ),
              Gap(screenHeight/100),
              Image(image: AssetImage('assets/LC-logo1.png'),height:screenHeight/10,width: screenWidth/3,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text('LEAD',style: GoogleFonts.oswald(color: Colors.white,fontSize: screenWidth/9,fontWeight: FontWeight.bold),
                 ),
                Gap(screenWidth/50),
                Text('CHESS',style: GoogleFonts.oswald(fontSize: screenWidth/9,fontWeight: FontWeight.bold,color: Colors.amberAccent),),

                ],
              ),
              Padding(
                padding:EdgeInsets.symmetric(horizontal:10.0),
                child:Container(
                  height:screenHeight/400,
                  width:screenWidth/2.2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white,Colors.amber, Colors.white],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                ),),
              Gap(screenHeight/17),
              CyberButtons(),
              // Padding(
              //   padding:  EdgeInsets.only(left: screenWidth/20),
              //   child: Row(
              //     children: [
              //       CyberButtons(routeName: '/Play Local',name: 'Play Local',imageUrl: 'assets/chesscoin.png',),
              //       CyberButtons(routeName: '/Play Online',name: 'Play Online',imageUrl: 'assets/chesscoin1.png',),
              //     ],
              //   ),
              // ),
              // Gap(screenHeight/25),
              // Row(
              //   children: [
              //     CyberButtons(routeName: '/Play with Friends',name: 'Play with Friends',imageUrl: 'assets/playfriend.png',),
              //     CyberButtons(routeName: '/Tournament',name: 'Tournament',imageUrl: 'assets/tournament.png',),
              //   ],
              // ),
              Gap(screenHeight/3.5),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                     BouncingWidget(
                      scaleFactor: _scaleFactor,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>GiftPage()));
                      },
                      
                     // => _onPressed(context),
                      child:   Padding(
                        padding: EdgeInsets.only(left: screenWidth/13),
                      child:Image(
                        image: AssetImage('assets/gift.png'),
                        height:screenHeight/17,width: screenWidth/8,fit: BoxFit.cover,),),
                  ),

                  BouncingWidget(
                      scaleFactor: _scaleFactor,
                      onPressed: () => _onPressed(context),
                    child:   Padding(
                        padding: EdgeInsets.only(right: screenWidth/17),
                      child: Image(
                        image: AssetImage('assets/leader.png'),
                        height:screenHeight/17,width: screenWidth/8,fit: BoxFit.cover,),),
                  ),

                ],
              ),
             // CyberButtons(),
              //Gap(screenHeight/25),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     CyberTwo(name: 'Play vs Friend',imageUrl: 'assets/people1.png', routeName: "/Play vs Friend",),
              //     CyberTwo(name: 'Play vs Computer',imageUrl: 'assets/play.png', routeName: "/Play vs Computer",),
              //     CyberTwo(name: 'Play Online',imageUrl: 'assets/play1.png', routeName: "/Play vs Online",)
              //   ],
              // ),
             // Gap(screenHeight/15),
              //CyberOne(),
            ],
          ),
        //),

     ),
    );
  }
}
