import 'package:get/get.dart';
import 'package:money_record/data/model/history.dart';
import 'package:money_record/data/source/source_history.dart';

class CDetailHistory extends GetxController {
  final _data = History().obs;
  final _loading = false.obs;

  bool get loading => _loading.value;
  History get data => _data.value;

  getData(idUser, date) async {
    _loading.value = true;
    update();
    History? history = await SourceHistory.whereDetail(idUser, date);

    _data.value = history ?? History();
    update();

    Future.delayed(const Duration(seconds: 1), () {
      _loading.value = false;
      update();
    });
  }
}
