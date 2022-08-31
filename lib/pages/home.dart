import 'package:d_chart/d_chart.dart';
import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_record/config/app_asset.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/data/model/user.dart';
import 'package:money_record/pages/auth/login.dart';
import 'package:money_record/pages/history/add.dart';
import 'package:money_record/pages/history/income_outcome_page.dart';
import 'package:money_record/presentasi/controller/c_home.dart';
import 'package:money_record/presentasi/controller/c_user.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cUser = Get.put(CUser());
  final cHome = Get.put(CHome());
  final box = GetStorage();
  @override
  void initState() {
    cHome.getAnalysis(cUser.data.idUser ?? box.read('user')['id_user']);
    final storageUser = box.read('user');
    print("storageUser: $storageUser");
    // print(cUser.data.toJson());
    super.initState();
  }

  logout() {
    DInfo.dialogSuccess('Logout success');

    DInfo.closeDialog(actionAfterClose: () {
      Session.clearUser();
      Get.off(() => const LoginPage());
      box.remove('user');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: drawer(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: Row(
                children: [
                  Image.asset(AppAsset.profile, width: 100, height: 100),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi,",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Obx(
                            () {
                              return Text(
                                cUser.data.name != null
                                    ? cUser.data.name.toString()
                                    : (box.read('user') != null
                                        ? box.read('user')['name'].toString()
                                        : ""),
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Builder(builder: (ctx) {
                    return Material(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColor.chart,
                      child: InkWell(
                        onTap: () {
                          Scaffold.of(ctx).openEndDrawer();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => cHome.getAnalysis(cUser.data.idUser!),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  children: [
                    Text(
                      "Pengeluaran hari ini",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    DView.spaceHeight(),
                    CardToday(context),
                    DView.spaceHeight(24),
                    Center(
                      child: Container(
                        height: 5,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColor.bg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    DView.spaceHeight(30),
                    Text(
                      "Pengeluaran Minggu sekarang",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    DView.spaceHeight(),
                    Weekly(),
                    DView.spaceHeight(30),
                    Text(
                      "Perbandingan Bulan ini",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Monthly(context),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Drawer drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            margin: EdgeInsets.only(bottom: 0),
            padding: EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Image.asset(AppAsset.profile, width: 80, height: 80),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () {
                                return Text(
                                  cUser.data.name == null
                                      ? (box.read('user') != null
                                          ? box.read('user')['name'].toString()
                                          : "")
                                      : cUser.data.name.toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                );
                              },
                            ),
                            Obx(
                              () {
                                return Text(
                                  cUser.data.email == null
                                      ? (box.read('user') != null
                                          ? box.read('user')['email'].toString()
                                          : "")
                                      : cUser.data.email.toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                DView.spaceHeight(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        logout();
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Text(
                          "Logout",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {
              Get.to(
                () => AddHistory(),
              )?.then((value) {
                if (value ?? false) {
                  cHome.getAnalysis(cUser.data.idUser!);
                }
              });
            },
            leading: Icon(Icons.add),
            horizontalTitleGap: 0,
            title: Text('Tambahan baru'),
            trailing: Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {
              Get.to(
                () => const IncomeOutcomePage(type: "Pemasukan"),
              );
            },
            leading: Icon(Icons.south_west),
            horizontalTitleGap: 0,
            title: Text('Pemasukan'),
            trailing: Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {
              Get.to(
                () => const IncomeOutcomePage(type: "Pengeluaran"),
              );
            },
            leading: Icon(Icons.north_east),
            horizontalTitleGap: 0,
            title: Text('Pengeluaran'),
            trailing: Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.history),
            horizontalTitleGap: 0,
            title: Text('Riwayat'),
            trailing: Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

  Row Monthly(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Stack(
            children: [
              Obx(() {
                return DChartPie(
                  data: [
                    {'domain': 'Income', 'measure': cHome.monthIncome},
                    {'domain': 'Outcome', 'measure': cHome.monthOutcome},
                    if (cHome.monthIncome == 0 && cHome.monthOutcome == 0)
                      {'domain': 'nol', 'measure': 1},
                  ],
                  fillColor: (pieData, index) {
                    switch (pieData['domain']) {
                      case 'Income':
                        return AppColor.primary;
                      case 'Outcome':
                        return AppColor.bg.withOpacity(0.1);
                      default:
                        return AppColor.bg.withOpacity(0.5);
                    }
                  },
                  donutWidth: 20,
                  labelColor: Colors.white,
                );
              }),
              Center(
                child: Obx(() {
                  return Text(
                    '${cHome.percentIncome}%',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: AppColor.primary,
                        ),
                  );
                }),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.chart,
                ),
                DView.spaceWidth(7),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pemasukan"),
                      Text(
                        AppFormat.currency(
                          cHome.monthIncome.toString(),
                        ),
                      ),
                    ],
                  );
                })
              ],
            ),
            DView.spaceHeight(8),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.bg,
                ),
                DView.spaceWidth(5),
                Obx(
                  () {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pengeluaran"),
                        Text(
                          AppFormat.currency(
                            cHome.monthOutcome.toString(),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
            DView.spaceHeight(18),
            Obx(() {
              return Text('${cHome.monthPercent}');
            }),
            Obx(() {
              return Text(
                AppFormat.currency(cHome.monthIncome.toString()),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.chart,
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  AspectRatio Weekly() {
    return AspectRatio(
      aspectRatio: 9 / 6,
      child: Obx(() {
        return DChartBar(
          data: [
            {
              'id': 'Bar',
              'data': List.generate(7, (index) {
                return {
                  'domain': cHome.weekText()[index],
                  'measure': cHome.week[index]
                };
              }),
            },
          ],
          domainLabelPaddingToAxisLine: 8,
          axisLineTick: 2,
          axisLineColor: AppColor.primary,
          measureLabelPaddingToAxisLine: 16,
          barColor: (barData, index, id) => AppColor.primary,
          showBarValue: true,
        );
      }),
    );
  }

  Material CardToday(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 8,
      color: AppColor.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Obx(() {
              return Text(
                AppFormat.currency(cHome.today.toString()),
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 65, 206, 201),
                    ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Obx(() {
              return Text(
                cHome.todayPercent,
                style: GoogleFonts.poppins(
                  color: AppColor.bg,
                  fontSize: 16,
                ),
              );
            }),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 0, 16),
            padding: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Selengkapnya"),
                Icon(Icons.navigate_next),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
