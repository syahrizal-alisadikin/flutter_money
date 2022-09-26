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

  static Future<History?> whereDate(
      String idhistory, String date, String type) async {
    String url = '${Api.baseUrl}/history/where_date.php';
    Map? responseBody = await AppRequest.post(
        url, {'id_history': idhistory, 'date': date, 'type': type});

    if (responseBody == null) return null;

    // Jika Success true, maka data history akan di return
    if (responseBody['success']) {
      var list = responseBody['data'];
      return History.fromJson(list);
    } else {
      return null;
    }
  }

  static Future<bool> update(String? idHistory, String? idUser, String? date,
      String? type, String? details, String total) async {
    String url = '${Api.baseUrl}/history/update.php';

    Map? responseBody = await AppRequest.post(url, {
      'id_history': idHistory,
      'id_user': idUser,
      'date': date,
      'type': type,
      'details': details,
      'total': total,
      'updated_at': DateTime.now().toIso8601String(),
    });
    if (responseBody == null) return false;

    if (responseBody['success']) {
      return true;
    } else {
      if (responseBody['message'] == 'date') {
        DInfo.dialogError('Date already exists');
      } else {
        DInfo.dialogError('Gagal Update History');
      }
      DInfo.closeDialog();
    }
    return responseBody['success'];
  }

  static Future<bool> delete(String? idHistory) async {
    String url = '${Api.baseUrl}/history/delete.php';

    Map? responseBody = await AppRequest.post(url, {
      'id_history': idHistory,
    });
    if (responseBody == null) return false;

    return responseBody['success'];
  }

  static Future<List<History>> getHistory(String idUser) async {
    String url = '${Api.baseUrl}/history/history.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
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

  static Future<List<History>> getHistorySearch(
      String idUser, String date) async {
    String url = '${Api.baseUrl}/history/history_search.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'date': date,
    });

    if (responseBody == null) return [];
    print(responseBody);
    // Jika Success true, maka data history akan di return
    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
