import 'package:get/get.dart';
import 'package:money_record/data/model/history.dart';
import 'package:money_record/data/source/source_history.dart';

class CHistory extends GetxController {
  final _loading = false.obs;

  bool get loading => _loading.value;
  final _list = <History>[].obs;

  List<History> get list => _list.value;

  getList(idUser) async {
    _loading.value = true;
    update();
    _list.value = await SourceHistory.getHistory(idUser);
    update();

    // Future.delayed(Duration(microseconds: 150000), () {
    //   _loading.value = false;
    //   update();
    // });

    Future.delayed(const Duration(seconds: 1), () {
      _loading.value = false;
      update();
    });
  }

  searchList(idUser, date) async {
    _loading.value = true;
    update();
    _list.value = await SourceHistory.getHistorySearch(idUser, date);
    update();

    // Future.delayed(Duration(microseconds: 150000), () {
    //   _loading.value = false;
    //   update();
    // });

    Future.delayed(const Duration(seconds: 1), () {
      _loading.value = false;
      update();
    });
  }
}
