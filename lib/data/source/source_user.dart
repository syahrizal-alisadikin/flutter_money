import 'package:d_info/d_info.dart';
import 'package:money_record/config/api.dart';
import 'package:money_record/config/app_request.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/data/model/user.dart';

class SourceUser {
  static Future<bool> login(String? email, String password) async {
    String url = '${Api.baseUrl}/user/login.php';

    Map? responseBody = await AppRequest.post(url, {
      'email': email,
      'password': password,
    });
    if (responseBody == null) return false;

    if (responseBody['login']) {
      var mapUser = responseBody['data'];
      Session.saveUser(User.fromJson(mapUser));
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
}
