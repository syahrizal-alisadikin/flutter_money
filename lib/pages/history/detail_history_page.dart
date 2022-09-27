import 'dart:convert';

import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';

import '../../presentasi/controller/history/c_detail_history.dart';

class DetailHistoryPage extends StatefulWidget {
  const DetailHistoryPage({Key? key, required this.idUser, this.date})
      : super(key: key);
  final String idUser;
  final String? date;

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  @override
  final cDetailHistory = Get.put(CDetailHistory());
  void initState() {
    cDetailHistory.getData(widget.idUser, widget.date);
    print(cDetailHistory.data);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Obx(() {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    AppFormat.date(cDetailHistory.data.date ?? widget.date!),
                  ),
                ),
                cDetailHistory.data.type == "Pemasukan"
                    ? const Icon(Icons.south_west, color: Colors.green)
                    : const Icon(Icons.north_east, color: Colors.red),
              ],
            );
          }),
        ),
        body: GetBuilder<CDetailHistory>(builder: (_) {
          if (_.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (_.data.date == null)
            return const Center(child: Text("Data tidak ditemukan"));
          List details = jsonDecode(_.data.details!);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text("Total",
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              DView.spaceHeight(8),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Text(
                    AppFormat.currency(cDetailHistory.data.total ?? "0"),
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: cDetailHistory.data.type == "Pemasukan"
                            ? AppColor.primary
                            : Colors.red)),
              ),
              DView.spaceHeight(20),
              Center(
                child: Container(
                  height: 5,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              DView.spaceHeight(20),
              Expanded(
                child: ListView.separated(
                  itemCount: details.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    indent: 25,
                    endIndent: 25,
                  ),
                  itemBuilder: (context, index) {
                    Map item = details[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}.',
                            style: const TextStyle(fontSize: 18),
                          ),
                          DView.spaceWidth(8),
                          Text(
                            item['name'],
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Spacer(),
                          Text(AppFormat.currency(item['price']),
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }));
  }
}
