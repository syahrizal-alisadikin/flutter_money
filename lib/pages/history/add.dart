import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/presentasi/controller/history/c_add_history.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddHistory extends StatelessWidget {
  const AddHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cAddHistory = Get.put(CAddHistory());
    final controllerName = TextEditingController();
    final controllerPrice = TextEditingController();
    return Scaffold(
      appBar: DView.appBarLeft(
        "Tambah History",
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text("Tanggal", style: GoogleFonts.poppins(fontSize: 16)),
          Row(
            children: [
              Obx(() {
                return Text(
                  cAddHistory.date,
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
                      cAddHistory
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
              value: cAddHistory.type,
              items: ["Pemasukan", "Pengeluaran"].map((e) {
                return DropdownMenuItem(
                  child: Text(e),
                  value: e,
                );
              }).toList(),
              onChanged: (value) {
                cAddHistory.setType(value);
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
                cAddHistory.addItem({
                  "name": controllerName.text,
                  "price": double.parse(controllerPrice.text),
                });
                controllerName.clear();
                controllerPrice.clear();
              },
              child: Text("Tambah ke Items")),
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
            child: GetBuilder<CAddHistory>(
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
                  AppFormat.currency(cAddHistory.total.toString()),
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
              onTap: () {},
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
