import 'package:d_chart/d_chart.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_record/config/app_asset.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/pages/auth/login.dart';
import 'package:money_record/presentasi/controller/c_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cUser = Get.put(CUser());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: Drawer(),
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
                                cUser.data.name ?? "Tidak ada ",
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
                    "Pengeluaran Minggu ini",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  DView.spaceHeight(),
                  AspectRatio(
                    aspectRatio: 9 / 6,
                    child: DChartBar(
                      data: [
                        {
                          'id': 'Bar',
                          'data': [
                            {'domain': '2020', 'measure': 3},
                            {'domain': '2021', 'measure': 4},
                            {'domain': '2022', 'measure': 6},
                            {'domain': '2023', 'measure': 0.3},
                          ],
                        },
                      ],
                      domainLabelPaddingToAxisLine: 16,
                      axisLineTick: 2,
                      axisLinePointTick: 2,
                      axisLinePointWidth: 10,
                      axisLineColor: Colors.green,
                      measureLabelPaddingToAxisLine: 16,
                      barColor: (barData, index, id) => Colors.green,
                      showBarValue: true,
                    ),
                  ),
                  DView.spaceHeight(30),
                  Text(
                    "Perbandingan Bulan ini",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Stack(
                          children: [
                            DChartPie(
                              data: [
                                {'domain': 'Flutter', 'measure': 28},
                                {'domain': 'React Native', 'measure': 27},
                              ],
                              fillColor: (pieData, index) => Colors.purple,
                              donutWidth: 30,
                              labelColor: Colors.white,
                            ),
                            Center(
                              child: Text(
                                "16%",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      color: AppColor.primary,
                                    ),
                              ),
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
                              Text("Pemasukan")
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
                              Text("Pengeluaran")
                            ],
                          ),
                          DView.spaceHeight(18),
                          Text("Pemasukan"),
                          Text("Lebih besar 20%"),
                          Text("dari pengeluaran"),
                          DView.spaceHeight(10),
                          Text("Atau Setara"),
                          Text(
                            "Rp 100.000",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.chart,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
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
            child: Text(
              "Rp 5000.000",
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 65, 206, 201),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Text(
              "20% Pengeluaran hari ini",
              style: GoogleFonts.poppins(
                color: AppColor.bg,
                fontSize: 16,
              ),
            ),
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
