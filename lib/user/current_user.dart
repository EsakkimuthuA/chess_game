


import 'package:chess_game/user/user_preference.dart';
import 'package:chess_game/user/users.dart';
import 'package:get/get.dart';


class CurrentUser extends GetxController
{
  final Rx<Users> _currentUser = Users(mobile: '', name: '', email: '', password: '', sessionToken: '', imagepath: '', userid: '',).obs;
  Users get users => _currentUser.value;
  getUserInfo() async
  {
    Users? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage?? Users(mobile: '', name: '', email: '', password: '', sessionToken: '', imagepath: '', userid: '',);
  }
  String getCurrentUserId() {
    return _currentUser.value.userid; // Accessing userid property
  }
}