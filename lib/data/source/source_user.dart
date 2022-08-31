import 'package:d_info/d_info.dart';
import 'package:get/state_manager.dart';
import 'package:money_record/config/api.dart';
import 'package:money_record/config/app_request.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/data/model/user.dart';
import 'package:get_storage/get_storage.dart';

class SourceUser {
  static Future<bool> login(String? email, String password) async {
    String url = '${Api.baseUrl}/user/login.php';
    final box = GetStorage();

    Map? responseBody = await AppRequest.post(url, {
      'email': email,
      'password': password,
    });
    if (responseBody == null) return false;

    if (responseBody['login']) {
      var mapUser = responseBody['data'];
      Session.saveUser(User.fromJson(mapUser));
      box.write('user', {
        'id_user': mapUser['id_user'],
        'name': mapUser['name'],
        'email': mapUser['email'],
        'password': mapUser['password'],
      });
    }
    // print('Info Login: ${responseBody['data']}');
    return responseBody['login'];
  }

  static Future<bool> register(
      String? name, String? email, String password) async {
    String url = '${Api.baseUrl}/user/register.php';

    Map? responseBody = await AppRequest.post(url, {
      'name': name,
      'email': email,
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
    if (responseBody == null) return false;

    if (responseBody['register']) {
      return true;
    } else {
      if (responseBody['message'] == 'email') {
        DInfo.dialogError('Email already exists');
      } else {
        DInfo.dialogError('Gagal Register');
      }
      DInfo.closeDialog();
    }

    return responseBody['register'];
  }

  RxBool toggle = true.obs;
}
