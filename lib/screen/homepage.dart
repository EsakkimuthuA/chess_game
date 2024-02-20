
import 'dart:async';
import 'dart:convert';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:chess_game/cyber/cyber_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colors_border/flutter_colors_border.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chess_game/colors.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:reward_popup/reward_popup.dart';
import '../gift_page.dart';
import '../profile_page.dart';
import '../setting_page.dart';
import '../user/current_user.dart';
import 'package:http/http.dart' as http;
import '../user/users.dart';
import 'home_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin{
  //final _key = GlobalKey<ScaffoldState>();
  final double _scaleFactor = 1.0;
  late Map<String, dynamic> userData = {};
  Users currentUser = Get.find<CurrentUser>().users;
  String? _profilePicturePath;

  Future<String?> fetchUserId(String userId, String email) async {
    try {
      final response = await http.post(
        Uri.parse('https://leadproduct.000webhostapp.com/chessApi/fetch_userid.php'),
        body: {
          'user_id': userId,
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('error');
        if (responseData.containsKey('userId')) {
          print('pass');
          return responseData['userId'].toString();
        } else if (responseData.containsKey('error')) {
          throw Exception(responseData['error']);
        } else {
          throw Exception('Unexpected response');
        }
      } else {
        throw Exception('Failed to fetch user ID: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user ID: $e');
      return null;
    }
  }

  Future<void> fetchProfilePicturePathAndUserId(String userId, String email) async {
    try {
      final response = await http.post(
        Uri.parse('https://leadproduct.000webhostapp.com/chessApi/fetch_profile_picture.php'),
        body: {
          'user_id': userId,
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if both userId and imagePath keys exist in the response data
        if (responseData.containsKey('userId') && responseData.containsKey('imagePath')) {
          final String userId = responseData['userId'];
          final String imagePath = responseData['imagePath'];

          // Assuming imagePath contains the file name only, concatenate it with the base URL
          final String baseUrl = 'https://leadproduct.000webhostapp.com/chessApi/';
          final String imageUrl = baseUrl + imagePath;

          setState(() {
            _userId = userId; // Update _userId with the fetched userId
            _profilePicturePath = imageUrl; // Update _profilePicturePath with the complete URL
          });
        } else {
          // Handle case where userId or imagePath is missing
          setState(() {
            _userId = null; // Set _userId to null or handle accordingly
            _profilePicturePath = null; // Set _profilePicturePath to null or a default image URL
          });
        }
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  //
  // Future<void> fetchProfilePicturePath(String userId, String email) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://leadproduct.000webhostapp.com/chessApi/fetch_profile_picture.php'),
  //       body: {
  //         'user_id': userId,
  //         'email': email,
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = jsonDecode(response.body);
  //
  //       // Check if the imagePath key exists in the response data
  //       if (!mounted) return;
  //       if (responseData.containsKey('imagePath')) {
  //         final String imagePath = responseData['imagePath'];
  //
  //         // Assuming imagePath contains the file name only, concatenate it with the base URL
  //         final String baseUrl = 'https://leadproduct.000webhostapp.com/chessApi/';
  //         final String imageUrl = baseUrl + imagePath;
  //
  //         setState(() {
  //           _profilePicturePath = imageUrl; // Update _profilePicturePath with the complete URL
  //         });
  //       } else {
  //         // Handle case where no image path is found
  //         setState(() {
  //           _profilePicturePath = null; // Set _profilePicturePath to null or a default image URL
  //         });
  //       }
  //     } else {
  //       throw Exception('Failed to fetch image data');
  //     }
  //   } catch (e) {
  //     print('Error fetching image: $e');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final rewardProvider = Provider.of<RewardAmountProvider>(context);
    // return FutureBuilder<void>(
    //     future: fetchProfilePicturePath(currentUser.userid, currentUser.email),
    // builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
    // if (snapshot.connectionState == ConnectionState.waiting) {
    // // Display a loading indicator while fetching the profile picture
    // return CircularProgressIndicator();
    // } else {
    return ChangeNotifierProvider(
        create: (context) => RewardAmountProvider(),
        // child: Consumer<RewardAmountProvider>(
        // builder: (context, provider, child) {
        //   child: Scaffold(
        //   body:
          child: Container(
            height: screenHeight/1,
            width: screenWidth/1,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/chess1.png'),
                    fit: BoxFit.cover)),
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
                              boardRadius: 50,
                              child:Container(
                                height: 50,
                                width: 50,
                                child:
                                // Consumer<ProfileProvider>(
                                //   builder: (context, profileProvider, _) {
                                //     final profilePicturePath = profileProvider.profilePicturePath;
                                //     return profilePicturePath != null
                                //         ? CircleAvatar(
                                //       radius: 50.0,
                                //       backgroundImage: NetworkImage(profilePicturePath),
                                //     )
                                //         : const CircleAvatar(
                                //          radius: 50.0,
                                //          child: Icon(Icons.person),
                                //     );
                                //   },
                                // ),
                                _profilePicturePath != null
                                    ? CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: NetworkImage(_profilePicturePath!), // Use _profilePicturePath directly
                                )
                                    : const CircleAvatar(
                                  radius: 50.0, child: Icon(Icons.person),)
                                ,)
                          ),
                        ),
                             // totalRewardAmount = provider.totalRewardAmount;
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
                                      width: screenWidth/16,), Container(
                                      height: screenHeight/32,
                                      width: screenWidth/7,
                                      child:  Center(
                                        child: Text('0',
                                          style: TextStyle(fontSize: 14,color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Image(image: AssetImage('assets/plus1.png'),
                                      height: screenHeight/28, width: screenWidth/23,),
                                  ],
                                ),
                              ),
                        Consumer<RewardAmountProvider>(
                            builder: (context, provider, child) {
                              return Container(
                                height: screenHeight / 32,
                                width: screenWidth / 4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: color.navy
                                ),
                                child: Row(
                                  children: [
                                    Image(image: AssetImage('assets/Dollar.png'),
                                      height: screenHeight / 25,
                                      width: screenWidth / 18,
                                    ),
                                    Container(
                                        height: screenHeight / 32,
                                        width: screenWidth / 7.5,
                                        child: Center(
                                            child: Text('$totalRewardAmount',
                                    style: TextStyle(color: Colors.white),))),
                                    Image(image: AssetImage('assets/plus1.png'),
                                      height: screenHeight / 28,
                                      width: screenWidth / 23,),
                                  ],
                                ),
                              );
                            }),
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
                        Text('LEAD',style: GoogleFonts.oswald(color: Colors.white,fontSize: screenWidth/9,fontWeight: FontWeight.bold),),
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
                    Gap(screenHeight/3.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BouncingWidget(
                          scaleFactor: _scaleFactor,
                          onPressed: () => _showOptionsDialog(context),
                          child: Padding(
                            padding: EdgeInsets.only(left: screenWidth/13),
                            child:Image(
                              image: AssetImage('assets/gift.png'),
                              height:screenHeight/17,width: screenWidth/8,fit: BoxFit.cover,),
                          ),
                        ),
                        BouncingWidget(
                          scaleFactor: _scaleFactor,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>GiftPage()));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: screenWidth/17),
                            child: Image(
                              image: AssetImage('assets/leader.png'),
                              height:screenHeight/17,width: screenWidth/8,fit: BoxFit.cover,),),
                        ),

                      ],
                    ),
                  ]
              ),
            ),
          )
        //  ),
        // }
        // )
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;
        return AlertDialog(
          title: Text('Free Coins'),
          content: Container(
            width: screenWidth * 0.8, // Set width to 80% of screen width
            height: screenHeight * 0.4, // Set height to 40% of screen height
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: screenHeight/10,
                  width: screenWidth/1.5,
                  decoration: BoxDecoration(
                    color: color.Brown,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: color.navy.withOpacity(0.55), width: 10.0
                      //   bottom: BorderSide(color: color.navy1, width: 3.0), // Set the border color and width for the bottom side
                    ),
                  ),
                  child: Row(
                    children: [
                      //SizedBox(width: 30,),
                      // Text('1   '),
                      Text('100    ',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                      Image(image: AssetImage('assets/coin4.png'),height: 30,width: 30,),
                      SizedBox(width: 30,),
                      MaterialButton(
                        color: Colors.green,
                        onPressed: () async {
                          if (await rewardAd.isLoaded) {
                            if (rewardedCount < 3) {
                              rewardAd.show();
                              rewardedCount++;
                            }else{
                              SnackBar(content: Text('your daily reward complete'),);
                            }
                          } else {
                            showSnackBar('Reward ad is still loading...');
                          }
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Reward Collect',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10),
                            ),
                            Image(image: AssetImage('assets/arrowf1.png'),height: 20,width: 25,color: Colors.white,),
                            //Icon(Icons.video_library_outlined,size: 30,color: Colors.green,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  AdmobBannerSize? bannerSize;
  late AdmobInterstitial interstitialAd;
  late AdmobReward rewardAd;
  int totalRewardAmount = 0;
  int rewardedCount = 0;
  late Timer dailyRewardedTimer;
  Future<void> updateUserTotalReward(String userId, int totalRewardAmount) async {
    print('Updating total reward for user $userId to $totalRewardAmount');
    try {
      final response = await http.post(
        Uri.parse('https://leadproduct.000webhostapp.com/chessApi/total_amount.php'),
        body: {
          'user_id': userId,
          'reward_amount': totalRewardAmount.toString(), // Changed from 'total_reward_amount' to 'reward_amount'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success']) {
          print('Total reward amount updated successfully');
        } else {
          print('Failed to update total reward amount');
        }
      } else {
        print('Failed to update total reward amount. Server error.');
      }
    } catch (e) {
      print('Error updating total reward amount: $e');
    }
  }
  @override
  void initState() {
    super.initState();

    //fetchProfilePicturePath(currentUser.userid, currentUser.email);
    fetchUserId(currentUser.userId,currentUser.email);
    updateUserTotalReward(currentUser.userId, totalRewardAmount);
    fetchProfilePicturePath(currentUser.userId, currentUser.email).then((_) {
      setState(() {
        _profilePicturePath = _profilePicturePath;
      });
    });
    dailyRewardedTimer = Timer.periodic(Duration(days: 1), (timer) {
      setState(() {
        rewardedCount = 0; // Reset rewarded count daily
      });
    });

    bannerSize = AdmobBannerSize.BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId()!,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    rewardAd = AdmobReward(
      adUnitId: getRewardBasedVideoAdUnitId()!,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        handleEvent(event, args, 'Reward');
      },
    );
    interstitialAd.load();
    rewardAd.load();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await Future.delayed(Duration(seconds: 5)); // Delay for 1 second before showing the ad
    //   showInterstitialAd();
    // });
  }

  @override
  void dispose() {
    dailyRewardedTimer.cancel();
    interstitialAd.dispose();
    rewardAd.dispose();
    super.dispose();
  }

  void showInterstitialAd() async {
    final isLoaded = await interstitialAd.isLoaded;
    if (isLoaded ?? false) {
      interstitialAd.show();
    }
  }

  Future<void> handleEvent(
      AdmobAdEvent event, Map<String, dynamic>? args, String adType) async {
    switch (event) {
      case AdmobAdEvent.loaded:
        setState(() {});
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        setState(() {});
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        setState(() {});
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        setState(() {});
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
      //  if (rewardedCount < 3) {
        final int customRewardAmount = 100;
        totalRewardAmount += customRewardAmount;
        setState(() {});
        final provider = Provider.of<RewardAmountProvider>(context, listen: false);
        provider.updateRewardAmount(customRewardAmount);
        updateUserTotalReward(currentUser.userId, totalRewardAmount);
        await Future.delayed(Duration(seconds: 1)).then((value) {
          showRewardPopup(
            context,
            enableDismissByTappingOutside: true,
            child: AlertDialog(
              backgroundColor: color.blue, // Change background color
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black,
                  width: 20,
                ),
                borderRadius: BorderRadius.circular(10.0),

              ),
              content: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  color: color.blue,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: color.navy.withOpacity(0.55), width: 10.0
                    //   bottom: BorderSide(color: color.navy1, width: 3.0), // Set the border color and width for the bottom side
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!',
                        style: GoogleFonts.oswald(fontWeight: FontWeight.w500,color: Colors.purple)),
                    Text('Type: ${args!['type']}',style: GoogleFonts.oswald(fontWeight: FontWeight.w500,color: Colors.purple)),
                    Text('Amount: $customRewardAmount',style: GoogleFonts.oswald(fontWeight: FontWeight.w500,color: Colors.purple)),
                    // Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
            ),
          );
        });
        //rewardedCount++;
        //   }
        break;
      default:
    }
  }


  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}



class UserPage extends StatefulWidget {
  final String userId;
  final String email;

  UserPage({required this.userId, required this.email});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _userId = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _email = widget.email;
    // Fetch user data here using _userId and _email
    fetchUserData(_userId, _email);
  }

  Future<void> fetchUserData(String userId, String email) async {
    try {
      final response = await http.post(
        Uri.parse('https://leadproduct.000webhostapp.com/chessApi/fetch_userid.php'),
        body: {
          'user_id': userId,
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Process the user data as needed
        print(responseData);
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('User ID: $_userId'),
            Text('Email: $_email'),
            // Add more widgets to display user data as needed
          ],
        ),
      ),
    );
  }
}
