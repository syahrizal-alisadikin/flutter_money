import 'dart:convert';
import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/data/source/source_history.dart';
import 'package:money_record/presentasi/controller/history/c_update_history.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/session.dart';
import '../../presentasi/controller/c_home.dart';
import '../../presentasi/controller/c_user.dart';

class UpadteHistory extends StatefulWidget {
  const UpadteHistory(
      {Key? key,
      required this.date,
      required this.type,
      required this.idHistory})
      : super(key: key);

  final String date;
  final String type;
  final String idHistory;
  user() async {
    final cUser = Get.put(CUser());
    final user = await Session.getUser();
    cUser.setData(user);
  }

  @override
  State<UpadteHistory> createState() => _UpdateHistoryState();
}

class _UpdateHistoryState extends State<UpadteHistory> {
  final cUpdateHistory = Get.put(CUpdateHistory());

  final cUser = Get.put(CUser());

  final cHome = Get.put(CHome());

  final controllerName = TextEditingController();

  final controllerPrice = TextEditingController();

  void initState() {
    final session = Get.put(Session.getUser());
    cUpdateHistory.init(widget.idHistory, widget.date, widget.type);
  }

  updateHistory() async {
    // print(cAddHistory.type);
    print(cUser.data.name);

    bool success = await SourceHistory.update(
      widget.idHistory,
      cUser.data.idUser!,
      cUpdateHistory.date,
      cUpdateHistory.type,
      jsonEncode(cUpdateHistory.items),
      cUpdateHistory.total.toString(),
    );

    if (success) {
      DInfo.dialogSuccess('Update history success');
      DInfo.closeDialog(actionAfterClose: () {
        Get.back(result: true);
        // Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft(
        "Update History",
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text("Tanggal", style: GoogleFonts.poppins(fontSize: 16)),
          Row(
            children: [
              Obx(() {
                return Text(
                  cUpdateHistory.date,
                  // cAddHistory.date,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.bold),
                );
              }),
              DView.spaceWidth(10),
              ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? result = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(DateTime.now().year + 1));
                    if (result != null) {
                      cUpdateHistory
                          .setDate(DateFormat('yyyy-MM-dd').format(result));
                    }
                  },
                  icon: Icon(Icons.calendar_today),
                  label: Text("Pilih Tanggal")),
            ],
          ),
          DView.spaceHeight(10),
          Text("Type",
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.bold)),
          DView.spaceHeight(4),
          Obx(() {
            return DropdownButtonFormField(
              value: cUpdateHistory.type,
              items: ["Pemasukan", "Pengeluaran"].map((e) {
                return DropdownMenuItem(
                  child: Text(e),
                  value: e,
                );
              }).toList(),
              onChanged: (value) {
                cUpdateHistory.setType(value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            );
          }),
          DView.spaceHeight(20),
          DInput(
            controller: controllerName,
            hint: "Pemasukan",
            title: "Pengeluaran/Pemasukan",
          ),
          DView.spaceHeight(20),
          DInput(
            controller: controllerPrice,
            hint: "30000",
            title: "Harga",
            inputType: TextInputType.number,
          ),
          DView.spaceHeight(20),
          ElevatedButton(
              onPressed: () {
                cUpdateHistory.addItem({
                  "name": controllerName.text,
                  "price": controllerPrice.text,
                });
                controllerName.clear();
                controllerPrice.clear();
              },
              child: const Text("Tambah ke Items")),
          DView.spaceHeight(10),
          Center(
            child: Container(
              height: 5,
              width: 100,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          DView.spaceHeight(20),
          Text(
            "Items",
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          DView.spaceHeight(4),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: GetBuilder<CUpdateHistory>(
              builder: (_) {
                return Wrap(
                  spacing: 8,
                  children: List.generate(
                    _.items.length,
                    (index) {
                      return Chip(
                        label: Text(_.items[index]["name"]),
                        deleteIcon: Icon(Icons.close),
                        onDeleted: () => _.deleteItem(index),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          DView.spaceHeight(20),
          Row(
            children: [
              Text(
                "Total :",
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
              DView.spaceWidth(10),
              Obx(() {
                return Text(
                  AppFormat.currency(cUpdateHistory.total.toString()),
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.primary,
                      ),
                );
              }),
            ],
          ),
          DView.spaceHeight(20),
          Material(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => updateHistory(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Text(
                    "SUBMIT",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
