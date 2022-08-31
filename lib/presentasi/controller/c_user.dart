import 'package:money_record/data/model/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CUser extends GetxController {
  final _data = User().obs;
  User get data => _data.value;
  setData(n) => _data.value = n;

  RxBool toggle = true.obs;
}
