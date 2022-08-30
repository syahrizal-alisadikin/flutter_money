import 'package:intl/intl.dart';
import 'package:money_record/config/api.dart';
import 'package:money_record/config/app_request.dart';
import 'package:d_info/d_info.dart';
import 'package:money_record/data/model/history.dart';

class SourceHistory {
  static Future<Map> analysis(String idUser) async {
    String url = '${Api.baseUrl}/history/analysis.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'today': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    });

    if (responseBody == null) {
      return {
        'today': 0,
        'yesterday': 0,
        'week': [0, 0, 0, 0, 0, 0, 0],
        'month': {
          'income': 0,
          'outcome': 0,
        }
      };
    }

    return responseBody;
  }

  static Future<bool> add(String? idUser, String? date, String? type,
      String? details, String total) async {
    String url = '${Api.baseUrl}/history/add.php';

    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'date': date,
      'type': type,
      'details': details,
      'total': total,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
    if (responseBody == null) return false;

    if (responseBody['success']) {
      return true;
    } else {
      if (responseBody['message'] == 'date') {
        DInfo.dialogError('Date already exists');
      } else {
        DInfo.dialogError('Gagal Tambah History');
      }
      DInfo.closeDialog();
    }
    return responseBody['success'];
  }

  static Future<List<History>> getInOut(String idUser, String type) async {
    String url = '${Api.baseUrl}/history/income_outcome.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'type': type,
    });

    if (responseBody == null) return [];

    // Jika Success true, maka data history akan di return
    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<List<History>> getInOutSearch(
      String idUser, String type, String date) async {
    String url = '${Api.baseUrl}/history/income_outcome_search.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'type': type,
      'date': date,
    });

    if (responseBody == null) return [];

    // Jika Success true, maka data history akan di return
    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
