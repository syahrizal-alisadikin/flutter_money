import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_record/config/app_asset.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/data/source/source_user.dart';
import 'package:money_record/pages/auth/login.dart';
import 'package:money_record/pages/home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final formValidation = GlobalKey<FormState>();
  register() async {
    if (formValidation.currentState!.validate()) {
      bool success = await SourceUser.register(
        controllerName.text,
        controllerEmail.text,
        controllerPassword.text,
      );
      print('Info: $success');
      if (success) {
        DInfo.dialogSuccess('Register Berhasil ! Silahkan Login');
        DInfo.closeDialog(actionAfterClose: () {
          Get.off(() => LoginPage());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DView.nothing(),
                  Form(
                    key: formValidation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Image.asset(AppAsset.logo),
                          DView.spaceHeight(24),
                          TextFormField(
                            controller: controllerName,
                            validator: (value) =>
                                value == "" ? 'Please enter your name' : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              fillColor: AppColor.primary.withOpacity(0.6),
                              filled: true,

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Masukan Name",
                              // labelText: 'Enter your username',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                          ),
                          DView.spaceHeight(16),
                          TextFormField(
                            controller: controllerEmail,
                            validator: (value) =>
                                value == "" ? 'Please enter your email' : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              fillColor: AppColor.primary.withOpacity(0.6),
                              filled: true,

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Masukan Email",
                              // labelText: 'Enter your username',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                          ),
                          DView.spaceHeight(16),
                          TextFormField(
                            controller: controllerPassword,
                            validator: (value) => value == ""
                                ? 'Please enter your password'
                                : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: AppColor.primary.withOpacity(0.6),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Masukan Password",
                              // labelText: 'Enter your username',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              suffixIcon: Icon(
                                Icons.visibility,
                                color: Color(0xff6F7075),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                          ),
                          DView.spaceHeight(30),
                          Material(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: () => register(),
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 12),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  // style: GoogleFonts.poppins(
                                  //   color: Colors.white,
                                  //   fontSize: 16,
                                  //   fontWeight: FontWeight.w400,
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun nih?',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            'Login',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
