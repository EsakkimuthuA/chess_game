import 'dart:async';
import 'package:chess_game/screen/home_screen.dart';
import 'package:chess_game/screen/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:chess_game/colors.dart';
import 'package:provider/provider.dart';
import 'package:reward_popup/reward_popup.dart';

// class RewardAmountProvider extends ChangeNotifier {
//   int _totalRewardAmount = 100;
//
//   int get totalRewardAmount => _totalRewardAmount;
//
//   void updateRewardAmount(int amount) {
//     _totalRewardAmount += amount;
//     notifyListeners();
//   }
// }

class NewPage extends StatefulWidget {
  final String title;
  final int totalRewardAmount; // Add this field
  const NewPage({
    Key? key,
    required this.title, required this.totalRewardAmount,
  }) : super(key: key);

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  late AdmobInterstitial _admobInterstitial;
  late AdmobReward _admobReward;
  @override
  void initState(){
    _admobInterstitial = createAdvert();
    _admobReward = createReward();
    super.initState();
  }
  AdmobReward createReward() {
    return AdmobReward(
      adUnitId: "ca-app-pub-3940256099942544/5224354917",
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.loaded) {
          _admobReward.show();
        } else if (event == AdmobAdEvent.closed) {
          _admobReward.dispose();
        } else if (event == AdmobAdEvent.rewarded) {
          print("type: ${args?["type"]}");
          print("reward: ${args?["amount"]}");
        }
      },
    );
  }
  AdmobInterstitial createAdvert() {
    return AdmobInterstitial(
      adUnitId: "ca-app-pub-3940256099942544/2247696110",
      //"ca-app-pub-3940256099942544/1033173712",
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.loaded) {
          _admobInterstitial.show();
        } else if (event == AdmobAdEvent.closed) {
          _admobInterstitial.dispose();
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          systemOverlayStyle: SystemUiOverlayStyle.light
      ).withBottomAdmobBanner(context),
      body: Column(
        children: [
          Container(
            color: Colors.green,
            child: Text('Total Reward Amount: ${widget.totalRewardAmount}'),
            
          ),
          MaterialButton(
              onPressed: ()=>_admobInterstitial.load(),
            child: Text('AdmobInterstitial'),

          ),
          MaterialButton(
            onPressed: ()=> _admobReward.load(),
            child: Text('AdmobReward'),

          )
        ],
      ),
    );
  }
}
class GiftPage extends StatefulWidget {
  const GiftPage({super.key});

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage>  with WidgetsBindingObserver{
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize? bannerSize;
  late AdmobInterstitial interstitialAd;
  late AdmobReward rewardAd;
  int totalRewardAmount = 0;
  int rewardedCount = 0;
  late Timer dailyRewardedTimer;
  @override
  void initState() {
    super.initState();
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    await Future.delayed(Duration(seconds: 5)); // Delay for 1 second before showing the ad
    showInterstitialAd();
    });
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
        await Future.delayed(const Duration(seconds: 3)).then((value) {
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    //final rewardProvider = Provider.of<RewardAmountProvider>(context);
    return Scaffold(
             key: scaffoldState,
             appBar: AppBar(
             title: const Text('Free Coins'),
            // leading: BackButton(
            //   onPressed: ()async{
            //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
            //   },
            // ),
            actions: [
              TextButton(
                onPressed: () async {
                  // Run this before displaying any ad.
                  Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true,
                      builder: (BuildContext context) {
                        return NewPage(
                          title: 'Full Screen Dialog',
                          totalRewardAmount: totalRewardAmount,);
                      },
                    ),
                  );
                },
                child: Text(
                  'FullscreenDialog',
                  style: TextStyle(
                    color: Colors.blue,

                  ),
                ),
              )
            ],
          ).withBottomAdmobBanner(context),
              body: Column(
                children: [
                  Container(
                  height: screenHeight/10,
                  width: screenHeight/1,
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
                    SizedBox(width: 30,),
                   // Text('1   '),
                    Text('100    ',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                    Image(image: AssetImage('assets/coin4.png'),height: 50,width: 50,),
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
                      child: Row(
                        children: [
                          Text(
                            'Reward Collect',
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                          ),
                          Image(image: AssetImage('assets/arrowf1.png'),height: 30,width: 35,color: Colors.white,),
                          //Icon(Icons.video_library_outlined,size: 30,color: Colors.green,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
                  ElevatedButton(
                    onPressed: () async {
                      await showRewardPopup(
                        context,
                        enableDismissByTappingOutside: true,
                        child: const Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Coupon Code'),
                              Text('Reach out to redeem'),
                              Text('abcd xyz'),
                            ],
                          ),
                        ),
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Popup dismissed"),
                          ),
                        );
                      }
                    },
                    child: const Text('Pop-up example four'),
                  ),
                  Container(
                   height: 50,
                    width: 200,
                   color: Colors.blue,
                   child: TextButton(
                    onPressed: () async {
                      final isLoaded = await interstitialAd.isLoaded;
                      if (isLoaded ?? false) {
                        interstitialAd.show();
                      } else {
                        showSnackBar(
                            'Interstitial ad is still loading...');
                      }
                    },
                    child: Text(
                      'Show Interstitial',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
              ),
                  AdmobBanner(
                    adUnitId: getBannerAdUnitId()!,
                    adSize: bannerSize!,
                    listener: (AdmobAdEvent event,
                        Map<String, dynamic>? args) {
                      handleEvent(event, args, 'Banner');
                    },
                    onBannerCreated:
                        (AdmobBannerController controller) {
                    },
                  ),
            ],
          ),
    );// .withBottomAdmobBanner(context);
  }
}


String? getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}

String? getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/1033173712';
  }
  return null;
}

String? getRewardBasedVideoAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/1712485313';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/5224354917';
  }
  return null;
}



class AppBarBannerRecipe extends StatelessWidget
    implements PreferredSizeWidget {
  final AppBar appBar;
  final Size size;

  const AppBarBannerRecipe({
    Key? key,
    required this.appBar,
    required this.size,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      Size.fromHeight(appBar.preferredSize.height + height);

  double get height => max(size.height * .06, 50.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        appBar,
        Container(
          width: size.width,
          height: height,
          child: AdmobBanner(
            adUnitId: getBannerAdUnitId()!,
            adSize: AdmobBannerSize.ADAPTIVE_BANNER(
              width: size.width.toInt(),
            ),
          ),
        )
      ],
    );
  }
}

extension AppBarAdmobX on AppBar {
  PreferredSizeWidget withBottomAdmobBanner(BuildContext context) {
    return AppBarBannerRecipe(
      appBar: this,
      size: MediaQuery.of(context).size,
    );
  }
}

class TopBannerAdAppRecipe extends StatelessWidget {
  const TopBannerAdAppRecipe({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
        child: Container(
          color: Colors.blueGrey,
          child: Column(children: [
            SafeArea(
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  final size = MediaQuery.of(context).size;
                  final height = max(size.height * .05, 50.0);
                  return Container(
                    width: size.width,
                    height: height,
                    child: AdmobBanner(
                      adUnitId: getBannerAdUnitId()!,
                      adSize: AdmobBannerSize.ADAPTIVE_BANNER(
                        width: size.width.toInt(),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(child: child),
          ]),
        ),
      ),
    );
  }
}

class BottomBannerAdAppRecipe extends StatelessWidget {
  const BottomBannerAdAppRecipe({
    Key? key,
    required this.child,
  }) : super(key: key);

  final MaterialApp child;

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return Directionality(
      textDirection: textDirection,
      child: MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance!.window),
        child: Container(
          color: Colors.blueGrey,
          child: Column(children: [
            Expanded(child: child),
            SafeArea(
              top: false,
              child: Builder(
                builder: (BuildContext context) {
                  final size = MediaQuery.of(context).size;
                  final height = max(size.height * .05, 50.0);
                  return Container(
                    width: size.width,
                    height: height,
                    child: AdmobBanner(
                      adUnitId: getBannerAdUnitId()!,
                      adSize: AdmobBannerSize.ADAPTIVE_BANNER(
                        width: size.width.toInt(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

extension MaterialAppX on MaterialApp {
  Widget withBottomAdmobBanner(BuildContext context) {
    return BottomBannerAdAppRecipe(
      child: this,
    );
  }
 }


