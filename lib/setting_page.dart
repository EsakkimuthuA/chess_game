import 'dart:io';
import 'package:chess_game/colors.dart';
import 'package:chess_game/login/phone_number_login.dart';
import 'package:chess_game/login/sign_in.dart';
import 'package:chess_game/login/sign_up.dart';
import 'package:chess_game/user/current_user.dart';
import 'package:chess_game/user/user_preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'engine/game_logic.dart';
import 'engine/home_screen_button.dart';
import 'engine/timer.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';


class ProfileProvider with ChangeNotifier {
  String? _profilePicturePath;

  String? get profilePicturePath => _profilePicturePath;

  set profilePicturePath(String? path) {
    _profilePicturePath = path;
    notifyListeners();
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final picker = ImagePicker();

  Future getImageFromCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      Provider.of<ProfileProvider>(context, listen: false)
          .profilePicturePath = pickedFile.path;
    } else {
      print('No image selected');
    }
  }

  Future getImageFromGallery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Provider.of<ProfileProvider>(context, listen: false)
          .profilePicturePath = pickedFile.path;
    } else {
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<ProfileProvider>(
              builder: (context, profileProvider, _) => profileProvider.profilePicturePath == null
                  ? Text('No image selected.')
                  : CircleAvatar(
                radius: 50.0,
                backgroundImage: FileImage(File(profileProvider.profilePicturePath!)),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => getImageFromCamera(context),
              child: Text('Take Picture'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => getImageFromGallery(context),
              child: Text('Choose from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}


// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   File? _image;
//   final picker = ImagePicker();
//   String? _profilePicturePath;
//   Future getImageFromCamera() async {
//     final pickedFile = await picker.getImage(source: ImageSource.camera);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         _profilePicturePath = pickedFile.path; // Save path for later use
//       } else {
//         print('No image selected');
//       }
//     });
//   }
//
//   Future getImageFromGallery() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         _profilePicturePath = pickedFile.path; // Save path for later use
//       } else {
//         print('No image selected');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Picture'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _profilePicturePath == null
//                 ? Text('No image selected.')
//                 : CircleAvatar(
//               radius: 50.0,
//               backgroundImage: FileImage(File(_profilePicturePath!)),
//             ),
//             // _image == null
//             //     ? Text('No image selected.')
//             //     : Image.file(
//             //   _image!,
//             //   height: 100.0,
//             //   width: 100.0,
//             // ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: getImageFromCamera,
//               child: Text('Take Picture'),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: getImageFromGallery,
//               child: Text('Choose from Gallery'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


final logic = GetIt.instance<GameLogic>();
class User {
  final String username;
  final IconData icon;

  const User({
    required this.username,
    required this.icon,});
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final CurrentUser _currentUser = Get.put(CurrentUser());
  late SharedPreferences prefs;


  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
  List<User> users=[
    const User(username: 'SignUp',icon: Icons.person),
    const User(username: 'Home',icon: Icons.home),
    const User(username: 'sounds', icon: Icons.surround_sound_rounded),
    const User(username: 'Rate this app', icon: Icons.star_rate),
  ];
  signOutUser() async
  {
    var resultResponse = await Get.dialog(
        AlertDialog(
          backgroundColor: Colors.grey,
          title: Text('logout'),
          actions: [
            TextButton(onPressed: (){
              Get.back();
            },
                child: Text("no",style: TextStyle(color: Colors.black),)),
            TextButton(onPressed: (){
              Get.back(result: 'loggedOut');
            },
                child: Text("yes",style: TextStyle(color: Colors.black),))
          ],
        )
    );
    if (resultResponse == "loggedOut")
    {
//delete-remove the user data from phone local storage
      RememberUserPrefs.removeUserInfo()
          .then((value)
      {
        Get.off (SignIn());
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    const minWidth = 250.0;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        title: Center(child: Text('Settings',style: TextStyle(color: Colors.white),)),
        backgroundColor: color.navy1
      ),
      body:  Container(
        height: screenHeight/1,
        width: screenWidth/1,
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/chess1.png'),
        fit: BoxFit.cover
        )),

        child:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             // SizedBox(height: 50,),
              Container(
                height: screenHeight/2,
                width: screenWidth/1.1,
                decoration: BoxDecoration(
                  // color: color.navy1.withOpacity(0.30)
                    borderRadius: BorderRadius.circular(12)
                ),
                // child: ListView.builder(
                //           itemCount: friends.length,
                //           itemBuilder: (BuildContext context, int index) {
                //             return FriendsList(child: friends[index],);
                //           },
                //         ),
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = users[index];
                    return GestureDetector(
                      // onTap: () {
                      //   // Navigate to the corresponding page based on the selected user
                      //   if (user.username == 'SignUp') {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                      //   } else if (user.username == 'Home') {
                      //    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                      //   }
                      //   // Add more conditions for other pages as needed
                      // },
                      child: Container(
                        height: screenHeight/14,
                        width: screenWidth/1.2,
                        decoration: BoxDecoration(
                          color: color.navy1.withOpacity(0.25),
                          border: Border(
                            bottom: BorderSide(color: color.navy1, width: 1.0), // Set the border color and width for the bottom side
                          ),
                        ),
                        child: Center(
                          child: ListTile(
                            onTap: () {
                              // Navigate to the corresponding page based on the selected user
                              if (user.username == 'SignUp') {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                              } else if (user.username == 'Home') {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                              }
                              // Add more conditions for other pages as needed
                            },
                            // textColor: color.navy1.withOpacity(0.25),
                            //  contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                            // tileColor: color.navy1.withOpacity(0.15),
                            leading:  Icon(user.icon,color: Colors.white,),
                            title: Text(user.username,style: TextStyle(fontSize: 13,color: Colors.white),),
                            splashColor: Colors.white,
                            selectedColor: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // MaterialButton(
              //   onPressed: (){
              //     Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneLoginPage()));
              //     },
              //   color: Colors.blueAccent,
              //   child: Text('phone number login'),),
            // HomeScreenButton(
            //   text: "Resume",
            //   minWidth: minWidth,
            //   onPressed: (context) {
            //     Navigator.pushNamed(context, '/resume');
            //   }
            // ),
              MaterialButton(
                child: Text("Start Game"),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage()));
                },
              ),
              // MaterialButton(
              //   child: Text("Start Game"),
              //   color: Colors.blue,
              //   textColor: Colors.white,
              //   onPressed: () {
              //     Navigator.pushNamed(context, ClockWidget.routeName);
              //   },
              // ),
            MaterialButton(
                onPressed: (){
                  signOutUser();
                },
                child: Text('Logout'),
                           color: Colors.blueAccent,

            ),
            Text(_currentUser.users.email,style: TextStyle(color: Colors.white),),
              Text(_currentUser.users.name,style: TextStyle(color: Colors.white),),
           // String sessionToken = prefs.getString('sessionToken') ?? '';
              FutureBuilder(
                future: initPrefs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    String sessionToken = prefs.getString('sessionToken') ?? '';
                    return Text(
                      'Session Token: $sessionToken',
                      style: TextStyle(color: Colors.white),
                    );
                  } else {
                    return CircularProgressIndicator(); // You can replace this with a loading indicator.
                  }
                },
              ),
      //     FutureBuilder(
      //       future: fetchData(),
      //       builder: (context, snapshot) {
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return CircularProgressIndicator();
      //         } else if (snapshot.hasError) {
      //           return Text('Error: ${snapshot.error}',style: TextStyle(color: Colors.white));
      //         } else {
      //           // Display the data in a ListView
      //           return ListView.builder(
      //             itemCount: snapshot.data!.length,
      //             itemBuilder: (context, index) {
      //               return ListTile(
      //                 title: Text(snapshot.data![index]['your_column_name'],style: TextStyle(color: Colors.white),),
      //               );
      //             },
      //           );
      //         }
      //       },
      // )
          ],
                ),
        ),
      )
    );
  }
  // Future<List<Map<String, dynamic>>> fetchData() async {
  //   final response = await http.post(
  //     Uri.parse('https://leadproduct.000webhostapp.com/chessApi/session_token'),
  //     body: {'email': 'user@example.com', 'password': 'password'},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // Parse the JSON response
  //     Map<String, dynamic> responseData = json.decode(response.body);
  //
  //     // Store the session token in local storage
  //     saveSessionTokenLocally(responseData['sessionToken']);
  //
  //     return responseData['userData'];
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // throw an exception.
  //     throw Exception('Failed to load data');
  //   }
  // }
  //
  // Future<void> saveSessionTokenLocally(String sessionToken) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('sessionToken', sessionToken);
  // }
  //
  // Future<String?> getSessionToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('sessionToken');
  // }

}
