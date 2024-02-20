import 'dart:convert';
import 'dart:io';
import 'package:chess_game/user/current_user.dart';
import 'package:chess_game/user/users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  // String? imagePath;
  final picker = ImagePicker();
  late Map<String, dynamic> userData = {};
  bool _isLoading = false;
  String? _profilePicturePath;
  Users currentUser = Get.find<CurrentUser>().users;
  @override
  void initState() {
    super.initState();
    loadUserData();
    fetchProfilePicturePath(currentUser.userId, currentUser.email);
    loadProfilePicturePath(currentUser.userId);
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      setState(() {
        userData = jsonDecode(userDataString);
      });
    }
  }

  Future<void> fetchProfilePicturePath(String userId, String email) async {
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

        // Check if the imagePath key exists in the response data
        if (responseData.containsKey('imagePath')) {
          final String imagePath = responseData['imagePath'];

          // Assuming imagePath contains the file name only, concatenate it with the base URL
          final String baseUrl = 'https://leadproduct.000webhostapp.com/chessApi/';
          final String imageUrl = baseUrl + imagePath;

          setState(() {
            _profilePicturePath = imageUrl; // Update _profilePicturePath with the complete URL
          });
        } else {
          // Handle case where no image path is found
          setState(() {
            _profilePicturePath = null; // Set _profilePicturePath to null or a default image URL
          });
        }
      } else {
        throw Exception('Failed to fetch image data');
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
  }
  void deleteProfileImage() async {
    try {
      Users currentUser = Get.find<CurrentUser>().users;
      var response = await http.post(
        Uri.parse('https://leadproduct.000webhostapp.com/chessApi/delete_image.php'),
        body: {
          'user_id': currentUser.userId,
          'email': currentUser.email,
        },
      );

      if (response.statusCode == 200) {
        // Successfully deleted profile image
        print('Profile image deleted successfully');
        setState(() {
          _profilePicturePath = null;
        });
        // Also update locally and in SharedPreferences if needed
      } else {
        // Failed to delete profile image
        print('Failed to delete profile image');
      }
    } catch (e) {
      print('Error deleting profile image: $e');
    }
  }
  Future<void> loadProfilePicturePath(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('profilePicturePath_$userId');
    if (path != null) {
      setState(() {
        _profilePicturePath = 'https://leadproduct.000webhostapp.com/chessApi/$path';
      });
    }
  }

  Future getImageFromCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _uploadImageAndUpdateProfile(context, currentUser.userId, File(pickedFile.path));
    } else {
      print('No image selected');
    }
  }

  Future getImageFromGallery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _uploadImageAndUpdateProfile(context, currentUser.userId, File(pickedFile.path));
    } else {
      print('No image selected');
    }
  }
  Future<void> _uploadImageAndUpdateProfile( BuildContext context, String userId, File image,) async {
    setState(() {
      _isLoading = true;
    });

    try {

      Users currentUser = Get.find<CurrentUser>().users;
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://leadproduct.000webhostapp.com/chessApi/profile_image.php'),
      );
      request.fields['user_id'] =  currentUser.userId;
      request.fields['email'] = currentUser.email;
      String fileName = 'profile_image_$userId.jpg';

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          filename: fileName,
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        // Get response body
        final responseBody = await response.stream.bytesToString();
        final imagePath = jsonDecode(responseBody)['imagePath'];
        // final String baseUrl = 'https://leadproduct.000webhostapp.com/chessApi/'; //
        // final String imageUrl = baseUrl + imagePath; // Construct complete image URL  //
        setState(() {
          _profilePicturePath = imagePath;
        });
        // Update profile picture path locally
        Provider.of<ProfileProvider>(context, listen: false).profilePicturePath = imagePath;
        // Save imagePath in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('profilePicturePath_$userId', imagePath);

        // Show success message or handle as needed
        print('Image uploaded successfully: $imagePath');
      } else {
        print('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context,) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Picture'),
        //leading: BackButton(color: Colors.black,),
      ),
      body:   SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
              children: <Widget>[
                Row(
                  children: [

                     _profilePicturePath != null
                        ? CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(_profilePicturePath!), // Use _profilePicturePath directly
                    )
                        : const CircleAvatar(
                          radius: 50.0,
                          child: Icon(Icons.person),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showImageOptionsDialog(context);
                      },
                      child:  _profilePicturePath != null
                      //userData.isNotEmpty
                          ? CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(
                          'https://leadproduct.000webhostapp.com/chessApi/cheque/profile_image_${userData['user_id'] ?? ''}.jpg',
                        ),
                      )
                          : const CircleAvatar(
                           radius: 50.0,
                           child: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(width: 50,),
                    Text(userData['name'] ?? '',style: TextStyle(fontSize: 20),)
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: deleteProfileImage, // Call deleteProfileImage() when the button is pressed
                ),
                userData.isNotEmpty
                    ? Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('Userid'),
                      subtitle: Text(userData['user_id'] ?? ''),
                    ),
                    ListTile(
                      title: Text('Email'),
                      subtitle: Text(userData['email'] ?? ''),
                    ),
                    ListTile(
                      title: Text('Name'),
                      subtitle: Text(userData['name'] ?? ''),
                    ),
                    ListTile(
                      title: Text('Mobile Number'),
                      subtitle: Text(userData['mobile'] ?? ''),
                    ),
                    ListTile(
                      title: Text('Session Token'),
                      subtitle: Text(userData['session_token'] ?? ''),
                    ),
                    ListTile(
                      title: Text('imageData'),
                      subtitle: Text(userData['image_path'] ?? ''),
                    ),
                  ],
                )
                    : const Center(
                     child: CircularProgressIndicator(),
                ),
              ],
            ),
      ),
    );
  }

  void _showImageOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take camera Picture'),
                onTap: () {
                  Navigator.pop(context); // Close popup menu
                  getImageFromCamera(context); // Get image from camera
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context); // Close popup menu
                  getImageFromGallery(context); // Get image from gallery
                },
              ),
            ],
          ),
        );
      },
    );
  }
  }
