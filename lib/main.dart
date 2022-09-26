import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:money_record/config/app_color.dart';
// import 'package:money_record/config/session.dart';
// import 'package:money_record/data/model/user.dart';
import 'package:money_record/pages/auth/login.dart';
import 'package:money_record/pages/home.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  initializeDateFormatting().then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    final storageUser = box.read('user');

    super.initState();
  }

  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: AppColor.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.secondary,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.primary, foregroundColor: Colors.white),
      ),
      home: box.read('user') != null ? const HomePage() : const LoginPage(),
      // home: FutureBuilder(
      //   builder: (context, AsyncSnapshot<User?> snapshot) {
      //     if (snapshot.data == null) {
      //       return const LoginPage();
      //     } else {
      //       return const HomePage();
      //     }
      //   },
      // ),
    );
  }
}
