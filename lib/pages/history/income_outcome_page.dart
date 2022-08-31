import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/data/model/history.dart';
import 'package:money_record/data/source/source_history.dart';
import 'package:money_record/pages/history/update.dart';
import 'package:money_record/pages/home.dart';
import 'package:money_record/presentasi/controller/history/c_add_history.dart';
import 'package:money_record/presentasi/controller/history/c_income_outcome.dart';
import 'package:get_storage/get_storage.dart';
import '../../config/session.dart';
import '../../presentasi/controller/c_user.dart';

class IncomeOutcomePage extends StatefulWidget {
  const IncomeOutcomePage({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<IncomeOutcomePage> createState() => _IncomeOutcomePageState();
}

class _IncomeOutcomePageState extends State<IncomeOutcomePage> {
  final box = GetStorage();

  final cinout = Get.put(CIncomeOutcome());
  final cUser = Get.put(CUser());
  final cAddHistory = Get.put(CAddHistory());
  final controllerDate = TextEditingController();

  menuOption(String value, History history) async {
    if (value == 'update') {
      Get.to(() => UpadteHistory(
            date: history.date.toString(),
            type: history.type.toString(),
            idHistory: history.idHistory.toString(),
          ))?.then((value) {
        if (value ?? false) {
          refresh();
        }
      });
    } else if (value == 'delete') {
      bool success = await SourceHistory.delete(history.idHistory.toString());
      if (success) {
        DInfo.dialogSuccess("Data berhasil di hapus");
        DInfo.closeDialog(actionAfterClose: () {
          refresh();
        });
      }
    }
  }

  refresh() async {
    await cinout.getList(
        cUser.data.idUser ?? box.read('user')['id_user'], widget.type);
    // print(cUser.data.idUser);
  }

  @override
  void initState() {
    // TODO: implement initState
    final session = Get.put(Session.getUser());

    // print(cUser.data.toJson());
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              Text(widget.type),
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
                          cinout.searchList(
                            cUser.data.idUser ?? box.read('user')["id_user"],
                            widget.type,
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          )),
      body: GetBuilder<CIncomeOutcome>(builder: (_) {
        if (_.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_.list.isEmpty) {
          return Center(
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
                child: Row(
                  children: [
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
                    PopupMenuButton(
                        itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'update',
                                child: Text('Update'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                        onSelected: (value) {
                          menuOption(value.toString(), history);
                        }),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
