import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/data/model/user.dart';
import 'package:money_record/pages/auth/login.dart';
import 'package:money_record/pages/home.dart';

void main() {
  initializeDateFormatting().then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
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
      home: FutureBuilder(builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.data == null) {
          return LoginPage();
        } else {
          return HomePage();
        }
      }),
    );
  }
}
