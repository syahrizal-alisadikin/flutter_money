import 'package:get/get.dart';
import 'package:money_record/data/model/history.dart';
import 'package:money_record/data/source/source_history.dart';

class CIncomeOutcome extends GetxController {
  final _loading = false.obs;

  bool get loading => _loading.value;
  final _list = <History>[].obs;

  List<History> get list => _list.value;

  getList(idUser, type) async {
    _loading.value = true;
    update();
    _list.value = await SourceHistory.getInOut(idUser, type);
    update();

    // Future.delayed(Duration(microseconds: 150000), () {
    //   _loading.value = false;
    //   update();
    // });

    Future.delayed(Duration(seconds: 1), () {
      _loading.value = false;
      update();
    });
  }

  searchList(idUser, type, date) async {
    _loading.value = true;
    update();
    _list.value = await SourceHistory.getInOutSearch(idUser, type, date);
    update();

    // Future.delayed(Duration(microseconds: 150000), () {
    //   _loading.value = false;
    //   update();
    // });

    Future.delayed(Duration(seconds: 1), () {
      _loading.value = false;
      update();
    });
  }
}
