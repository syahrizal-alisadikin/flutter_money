import 'dart:convert';

import 'package:money_record/data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../presentasi/controller/c_user.dart';

class Session {
  // Save user to shared preferences
  static Future<bool> saveUser(User user) async {
    final pref = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap = user.toJson();

    String stringUser = jsonEncode(userMap);
    bool success = await pref.setString('user', stringUser);
    if (success) {
      final cUser = Get.put(UserController());
      cUser.setData(user);
    }
    return success;
  }

  // Get user from shared preferences
  static Future<User> getUser() async {
    User user = User();
    final pref = await SharedPreferences.getInstance();
    String? stringUser = pref.getString('user');

    if (stringUser == null) {
      return user;
    }
    Map<String, dynamic> userMap = jsonDecode(stringUser);
    final cUser = Get.put(UserController());
    cUser.setData(user);
    return User.fromJson(userMap);
  }

  // Clear user from shared preferences
  static Future<bool> clearUser() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('user');
    final cUser = Get.put(UserController());
    cUser.setData(User());
    return success;
  }
}
