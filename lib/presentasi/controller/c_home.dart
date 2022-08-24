import 'package:money_record/data/source/source_history.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CHome extends GetxController {
  final _today = 0.0.obs;

  double get today => _today.value;
  final _todayPercent = ''.obs;
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

  // Month
  final _monthIncome = 0.0.obs;
  double get monthIncome => _monthIncome.value;

  final _monthOutcome = 0.0.obs;
  double get monthOutcome => _monthOutcome.value;

  final _percentIncome = 0.0.obs;
  double get percentIncome => _percentIncome.value;
  final _percentOutcome = 0.0.obs;
  double get percentOutcome => _percentOutcome.value;

  final _montPercent = "".obs;
  String get monthPercent => _montPercent.value;

  final _monthDiferent = 0.0.obs;
  double get monthDiferent => _monthDiferent.value;

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
            ? '+${percent.toStringAsFixed(0)}% dibanding kemarin'
            : '-${percent.toStringAsFixed(0)}% dibanding kemarin';

    // Mingguan data nya array
    _weeks.value =
        List<double>.from(data['week'].map((e) => e.toDouble()).toList());
    // List.castFrom(data['week'].map((e) => e.toDouble()).toList());

    // Bulanan
    _monthIncome.value = data['month']['income'].toDouble();
    _monthOutcome.value = data['month']['outcome'].toDouble();
    _monthDiferent.value = (monthIncome - monthOutcome).abs();
    bool isSameMonth = monthIncome.isEqual(monthOutcome);
    bool isPlusMonth = monthIncome.isGreaterThan(monthOutcome);

    double byOutCome = monthOutcome == 0 ? 1 : monthOutcome;
    double byInCome = monthIncome == 0 ? 1 : monthIncome;
    double monthPercent = (monthDiferent / byOutCome) * 100;
    _percentIncome.value = (monthDiferent / byInCome) * 100;
    _percentOutcome.value = (monthDiferent / byOutCome) * 100;
    _montPercent.value = isSameMonth
        ? "Pemasukan \n100% sama \n dengan bulan lalu"
        : isPlusMonth
            ? 'Pemasukan \n+${monthPercent.toStringAsFixed(0)}% dibanding \n bulan lalu'
            : 'Pemasukan \n-${monthPercent.toStringAsFixed(0)}% dibanding \n bulan lalu';
  }
}
