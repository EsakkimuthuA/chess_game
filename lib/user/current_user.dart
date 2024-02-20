


import 'package:chess_game/user/user_preference.dart';
import 'package:chess_game/user/users.dart';
import 'package:get/get.dart';


class CurrentUser extends GetxController
{
  final Rx<Users> _currentUser = Users(mobile: 'mobile', name: 'name', email: 'email', password: 'password', sessionToken: 'session_token', userId: 'user_id', imagePath: 'image_path',).obs;
  Users get users => _currentUser.value;
  getUserInfo() async
  {
    Users? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage?? Users(mobile: 'mobile', name: 'name', email: 'email', password: 'password', sessionToken: 'session_token', userId: 'user_id', imagePath: 'image_path',);
  }
  String getCurrentUserId() {
    return _currentUser.value.userId; // Accessing userid property
  }
}