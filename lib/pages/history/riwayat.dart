import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../config/app_color.dart';
import '../../config/app_format.dart';
import '../../data/model/history.dart';
import '../../data/source/source_history.dart';
import '../../presentasi/controller/c_user.dart';
import '../../presentasi/controller/history/c_history.dart';
import 'detail_history_page.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final controllerDate = TextEditingController();
  final cHistory = Get.put(CHistory());
  final cUser = Get.put(CUser());
  final box = GetStorage();

  refresh() async {
    await cHistory.getList(cUser.data.idUser ?? box.read('user')['id_user']);
    // print(cUser.data.idUser);
  }

  // menuOption(String value, History history) async {
  //   if (value == 'delete') {
  //     bool success = await SourceHistory.delete(history.idHistory.toString());
  //     if (success) {
  //       DInfo.dialogSuccess("Data berhasil di hapus");
  //       DInfo.closeDialog(actionAfterClose: () {
  //         refresh();
  //       });
  //     }
  //   }
  // }

  delete(String idHistory) async {
    bool? yes = await DInfo.dialogConfirmation(
        context, 'Hapus', 'Hapus history ini?',
        textNo: "Batal", textYes: "Hapus");

    if (yes ?? false) {
      bool success = await SourceHistory.delete(idHistory);
      if (success) {
        DInfo.dialogSuccess("Data berhasil di hapus");
        DInfo.closeDialog(actionAfterClose: () {
          refresh();
        });
      }
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const Text('Riwayat'),
            Expanded(
                child: Container(
              height: 40,
              margin: const EdgeInsets.all(16),
              child: TextField(
                controller: controllerDate,
                onTap: () async {
                  DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(DateTime.now().year + 1));
                  if (result != null) {
                    controllerDate.text =
                        DateFormat('yyyy-MM-dd').format(result);
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColor.bg,
                  suffixIcon: IconButton(
                    onPressed: () {
                      cHistory.searchList(
                        cUser.data.idUser ?? box.read('user')["id_user"],
                        controllerDate.text,
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  hintText: controllerDate.text == ""
                      ? "Pilih tanggal"
                      : controllerDate.text,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ))
          ],
        ),
      ),
      body: GetBuilder<CHistory>(builder: (_) {
        if (_.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_.list.isEmpty) {
          return const Center(
            child: Text("Tidak ada data"),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => refresh(),
          child: ListView.builder(
            itemCount: _.list.length,
            itemBuilder: (context, index) {
              History history = _.list[index];
              return Card(
                elevation: 6,
                margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                    index == _.list.length - 1 ? 16 : 8),
                child: InkWell(
                  onTap: () => {
                    Get.to(() => DetailHistoryPage(
                          idUser: box.read('user')['id_user'],
                          date: history.date,
                        ))
                  },
                  child: Row(
                    children: [
                      DView.spaceWidth(12),
                      history.type == "Pemasukan"
                          ? const Icon(Icons.south_west, color: Colors.green)
                          : const Icon(Icons.north_east, color: Colors.red),
                      DView.spaceWidth(12),
                      Text(
                        AppFormat.date(history.date!),
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primary),
                      ),
                      Expanded(
                        child: Text(
                          AppFormat.currency(history.total!),
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      // PopupMenuButton(
                      //     itemBuilder: (context) => [
                      //           const PopupMenuItem(
                      //             value: 'delete',
                      //             child: Text('Delete'),
                      //           ),
                      //         ],
                      //     onSelected: (value) {
                      //       menuOption(value.toString(), history);
                      //     }),
                      // icon delete
                      IconButton(
                        onPressed: () {
                          delete(history.idHistory.toString());
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
