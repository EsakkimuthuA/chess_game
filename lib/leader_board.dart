// class ProfileProvider with ChangeNotifier {
//   String? _profilePicturePath;
//
//   String? get profilePicturePath => _profilePicturePath;
//
//   set profilePicturePath(String? path) {
//     _profilePicturePath = path;
//     notifyListeners();
//   }
// }
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final picker = ImagePicker();
//   late Map<String, dynamic> userData = {};
//
//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }
//   int getUserId() {
//     // Logic to fetch user ID, this could come from SharedPreferences, Provider, or any other source
//     return 123; // Replace with actual user ID
//   }
//   Future<void> loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userDataString = prefs.getString('userData');
//     if (userDataString != null) {
//       setState(() {
//         userData = jsonDecode(userDataString);
//       });
//     }
//   }
//
//   Future getImageFromCamera(BuildContext context) async {
//     final pickedFile = await picker.getImage(source: ImageSource.camera);
//     int userId = getUserId();
//     if (pickedFile != null) {
//       uploadImage(File(pickedFile.path),userId);
//       Provider
//           .of<ProfileProvider>(context, listen: false)
//           .profilePicturePath = pickedFile.path;
//     } else {
//       print('No image selected');
//     }
//   }
//
//   Future getImageFromGallery(BuildContext context) async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     int userId = getUserId();
//     if (pickedFile != null) {
//       Provider
//           .of<ProfileProvider>(context, listen: false)
//           .profilePicturePath = pickedFile.path;
//       uploadImage(File(pickedFile.path),userId);
//     } else {
//       print('No image selected');
//     }
//   }
//   Future<void> uploadImage(File image, int userId) async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('https://leadproduct.000webhostapp.com/chessApi/profile_image.php'), // Replace with your PHP API URL
//       );
//
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'image',
//           image.path,
//         ),
//       );
//
//       // Add user ID to the request
//       request.fields['user_id'] = userId.toString(); // Assuming userId is an integer
//
//       var response = await request.send();
//      // print(response.statusCode);
//       if (response.statusCode == 200) {
//         print('Image uploaded successfully');
//       } else {
//         print('Failed to upload image');
//       }
//     } catch (e) {
//       // Handle any exceptions or errors that occur during the HTTP request.
//       print('Error: image Error : $e');
//     }
//   }
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Profile Picture'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Consumer<ProfileProvider>(
//                 builder: (context, profileProvider, _) =>
//                 profileProvider.profilePicturePath == null
//                     ? Text('No image selected.')
//                     : CircleAvatar(
//                   radius: 50.0,
//                   backgroundImage: FileImage(
//                       File(profileProvider.profilePicturePath!)),
//                 ),
//               ),
//               SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: () => getImageFromCamera(context),
//                 child: Text('Take Picture'),
//               ),
//               SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: () => getImageFromGallery(context),
//                 child: Text('Choose from Gallery'),
//               ),
//               SizedBox(height: 20.0),
//               // userData.isNotEmpty
//               //     ? Column(
//               //   children: <Widget>[
//               //     ListTile(
//               //       title: Text('Email'),
//               //       subtitle: Text(userData['email'] ?? ''),
//               //     ),
//               //     ListTile(
//               //       title: Text('Name'),
//               //       subtitle: Text(userData['name'] ?? ''),
//               //     ),
//               //     ListTile(
//               //       title: Text('Mobile Number'),
//               //       subtitle: Text(userData['mobile'] ?? ''),
//               //     ),
//               //     ListTile(
//               //       title: Text('Session Token'),
//               //       subtitle: Text(userData['sessionToken'] ?? ''),
//               //     ),
//               //     ListTile(
//               //       title: Text('imageData'),
//               //       subtitle: Text(userData['imageData'] ?? ''),
//               //     ),
//               //   ],
//               // )
//               //     : Center(
//               //   child: CircularProgressIndicator(),
//               // ),
//               userData.isNotEmpty
//                   ? Column(
//                 children: userData.entries
//                     .map((entry) =>
//                     ListTile(
//                       title: Text(entry.key, style: TextStyle(color: Colors
//                           .black),),
//                       subtitle: Text(
//                         entry.value.toString(), style: TextStyle(color: Colors
//                           .black),),
//                     ))
//                     .toList(),
//               )
//                   : Center(
//                      child: CircularProgressIndicator(),
//               ),
//
//             ],
//           ),
//         ),
//       );
//     }
//   }


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


///////

// if (_profilePicturePath != null)
//   CircleAvatar(
//     radius: 50,
//     backgroundImage: NetworkImage(_profilePicturePath!),
//   ),
// _profilePicturePath != null
//     ? CircleAvatar(
//   radius: 50.0,
//   backgroundImage: NetworkImage('https://leadproduct.000webhostapp.com/chessApi/$_profilePicturePath')
//
// )
//     : CircleAvatar(
//   radius: 50.0,
//   child: Icon(Icons.person),
// ),
// CircleAvatar(
//   radius: 50.0,
// Container(
//   height: 50,
//   width: 50,
//   child: _profilePicturePath != null
//       ? FadeInImage.assetNetwork(
//     placeholder:'assets/placeholder_image.png', // Placeholder image while loading or if image not found
//     image: 'https://leadproduct.000webhostapp.com/chessApi/cheque/profile_image_${userData['user_id'] ?? ''}.jpg',
//     //  currentUser.userid
//     fit: BoxFit.cover,
//     imageErrorBuilder: (context, error, stackTrace) {
//       return  Image(image: AssetImage('assets/placeholder_image.png'));
//     },
//   )
//       : CircularProgressIndicator(),
// ),
// _profilePicturePath != null
//     ? CircleAvatar(
//   radius: 50.0,
//   backgroundImage: NetworkImage(
//     'https://leadproduct.000webhostapp.com/chessApi/cheque/profile_image_${userData['user_id'] ?? ''}.jpg',),
// )
//     : Text('No image selected.'),

// Consumer<ProfileProvider>(
//   builder: (context, profileProvider, _) => profileProvider.
//     _profilePicturePath != null
//       ?  Text('No image selected.')
// CircleAvatar(
//  radius: 50.0,
//  backgroundImage: NetworkImage('https://leadproduct.000webhostapp.com/chessApi/cheque/profile_image_${currentUser.userid}.jpg'),
//)
//     :
//  CircleAvatar(
//    radius: 50.0,
//    backgroundImage: NetworkImage('https://leadproduct.000webhostapp.com/chessApi/cheque/profile_image_${currentUser.userid}.jpg'),
//  ),
//   ),

// SizedBox(height: 20.0),
// Row(
//   children: [
//     ElevatedButton(
//       onPressed: () => getImageFromCamera(context),
//       child: Text('Take Picture'),
//     ),
//     SizedBox(height: 20.0),
//     ElevatedButton(
//       onPressed: () => getImageFromGallery(context),
//       child: Text('Choose from Gallery'),
//     ),
//   ],
// ),
// SizedBox(height: 20.0),
// Expanded(
//   child:ListView.builder(
//     itemCount: userDataList.length,
//     itemBuilder: (context, index) {
//       final userData = userDataList[index];
//       return ListTile(
//         title: Text(userData['name'] ?? ''),
//         subtitle: userData['image_path'] != null
//             ? Image.network(
//           'https://leadproduct.000webhostapp.com/${userData['image_path']}',
//           scale: 1.0,
//         )
//             : Text('No image available'),
//       );
//     },
//   ),
// ),
//     userData.isNotEmpty
//         ? Column(
//       children: userData.entries
//           .map((entry) => ListTile(
//         title: Text(
//           entry.key,
//           style: TextStyle(color: Colors.black),
//         ),
//         subtitle: Text(
//           entry.value.toString(),
//           style: TextStyle(color: Colors.black),
//         ),
//       ))
//           .toList(),
//     )
//         : Center(
//           child: CircularProgressIndicator(),
//     ),





//   Future<void> fetchProfilePicturePath(String userId, String email) async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://leadproduct.000webhostapp.com/chessApi/fetch_profile_picture.php'),
//         body: {
//           'user_id': userId,
//           'email': email,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         final String imagePath = responseData['imagePath'];
//
//         // Assuming imagePath contains the file name only, concatenate it with the base URL
//         const String baseUrl = 'https://leadproduct.000webhostapp.com/chessApi/';
//         final String imageUrl = baseUrl + imagePath;
//
//         setState(() {
//           _profilePicturePath = imageUrl; // Update _profilePicturePath with the complete URL
//         });
//       } else {
//         throw Exception('Failed to fetch image data');
//       }
//     } catch (e) {
//       print('Error fetching image: $e');
//     }
//   }
// // Delete image
//   Future<void> deleteProfilePicture(String userId, String email) async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://leadproduct.000webhostapp.com/chessApi/delete_profile_picture.php'),
//         body: {
//           'user_id': userId,
//           'email': email,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         print('Image deleted successfully');
//         // Clear the profile picture path locally
//         setState(() {
//           _profilePicturePath = null;
//         });
//       } else {
//         print('Failed to delete image');
//       }
//     } catch (e) {
//       print('Error deleting image: $e');
//     }
//   }
