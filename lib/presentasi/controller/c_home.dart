import 'package:money_record/data/source/source_history.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CHome extends GetxController {
  final _today = 0.0.obs;

  double get today => _today.value;
  final _todayPercent = '0'.obs;
  String get todayPercent => _todayPercent.value;

  final _weeks = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;

  List<double> get weeks => _weeks.value;

  List<String> get days => ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  List<String> weekText() {
    DateTime today = DateTime.now();

    return [
      days[today.subtract(const Duration(days: 6)).weekday - 1],
      days[today.subtract(const Duration(days: 5)).weekday - 1],
      days[today.subtract(const Duration(days: 4)).weekday - 1],
      days[today.subtract(const Duration(days: 3)).weekday - 1],
      days[today.subtract(const Duration(days: 2)).weekday - 1],
      days[today.subtract(const Duration(days: 1)).weekday - 1],
      days[today.weekday - 1],
    ];
  }

  getAnalysis(String idUser) async {
    Map data = await SourceHistory.analysis(idUser);

    _today.value = data['today'].toDouble();
    double yesterday = data['yesterday'].toDouble();
    double diferent = (today - yesterday).abs();
    bool isSame = today.isEqual(yesterday);
    bool isPlus = today.isGreaterThan(yesterday);

    double byYesterday = yesterday == 0 ? 1 : yesterday;
    double percent = (diferent / byYesterday) * 100;

    _todayPercent.value = isSame
        ? "100% sama dengan hari lalu"
        : isPlus
            ? '+${percent.toStringAsFixed(1)}% dibanding kemarin'
            : '-${percent.toStringAsFixed(1)}% dibanding kemarin';

    // Mingguan data nya array
    _weeks.value = data['yesterday'].map((e) => e.toDouble()).toList();
  }
}
