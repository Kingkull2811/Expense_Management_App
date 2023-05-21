import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:viet_wallet/screens/setting/export_excel/export_bloc.dart';
import 'package:viet_wallet/screens/setting/export_excel/export_state.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';

import '../../../network/model/wallet.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/primary_button.dart';
import 'export_event.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  late ExportBloc _exportBloc;

  String dateStart = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String? dateEnd;

  int? walletId;
  String? walletName;
  String? walletType;

  @override
  void initState() {
    _exportBloc = BlocProvider.of<ExportBloc>(context)..add(Initial());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _exportBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Xuất file excel',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocConsumer<ExportBloc, ExportState>(
        listener: (context, state) {
          if (state is ErrorServerState) {
            showMessage1OptionDialog(context, 'Error!',
                content: 'Internal_server_error');
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return AnimationLoading();
          } else {
            return _body(state);
          }
        },
      ),
    );
  }

  Widget _body(ExportState state) {
    List<Wallet> listWallet = [];
    if (state is ExportInitial) {
      listWallet = state.listWallet;
    } else {
      listWallet = [];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _selectDateStart(),
        Divider(
          height: 0.5,
          color: Colors.grey.withOpacity(0.3),
        ),
        _selectDateEnd(),
        Divider(
          height: 0.5,
          color: Colors.grey.withOpacity(0.3),
        ),
        _selectWallet(listWallet),
        Divider(
          height: 0.5,
          color: Colors.grey.withOpacity(0.3),
        ),
        Padding(
          padding: EdgeInsets.only(top: 32),
          child: PrimaryButton(
            text: 'Xuất file',
            onTap: () {
              if (walletId != null) {
                List<int> walletIDs = [];
                walletIDs.add(walletId!);
                _exportBloc.add(GetExport(
                  walletIDs: walletIDs,
                  formDate: dateStart,
                  toDate: dateEnd ?? '',
                ));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _selectWallet(List<Wallet>? listWallet) {
    return ListTile(
      onTap: () async {
        await _getWallet(listWallet);
      },
      dense: false,
      horizontalTitleGap: 6,
      leading: Icon(
        isNotNullOrEmpty(walletType)
            ? getIconWallet(walletType: walletType!)
            : Icons.help_outline,
        size: 30,
        color: Colors.grey,
      ),
      title: Text(
        walletName ?? 'Chọn tài khoản/ ví',
        style: TextStyle(
          fontSize: 16,
          color: isNotNullOrEmpty(walletName) ? Colors.black : Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }

  Widget _selectDateStart() {
    return ListTile(
      onTap: () {
        DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          minTime: DateTime(2000, 01, 01),
          maxTime: DateTime(2025, 12, 30),
          locale: LocaleType.vi,
          currentTime: DateTime.now(),
          onConfirm: (date) {
            setState(() {
              dateStart = DateFormat('yyyy-MM-dd').format(date);
            });
          },
          onCancel: () {
            setState(() {});
          },
        );
      },
      dense: false,
      visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
      leading: const Icon(
        Icons.calendar_month,
        size: 30,
        color: Colors.grey,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ngày bắt đầu',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.withOpacity(0.4),
            ),
          ),
          Text(
            dateStart,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }

  Future _getWallet(List<Wallet>? listWallet) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24,
              ),
            ),
            centerTitle: true,
            title: const Text(
              'Chọn tài khoản',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isNullOrEmpty(listWallet)
                ? Text(
                    'Không có dữ liệu tài khoản, vui lòng thêm tài khoản mới.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : ListView.builder(
                    itemCount: listWallet!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              walletId = listWallet[index].id;
                              walletName = listWallet[index].name;
                              walletType = listWallet[index].accountType;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).backgroundColor,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Icon(
                                    isNotNullOrEmpty(
                                            listWallet[index].accountType)
                                        ? getIconWallet(
                                            walletType:
                                                listWallet[index].accountType,
                                          )
                                        : Icons.help,
                                    size: 30,
                                    color: Colors.grey.withOpacity(0.6),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        listWallet[index].name ?? '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${listWallet[index].accountBalance} ${listWallet[index].currency}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (walletId == listWallet[index].id)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Icon(
                                      Icons.check_circle_outline,
                                      color: Theme.of(context).primaryColor,
                                      size: 24,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
          ),
        ),
      ),
    ).whenComplete(() {
      setState(() {});
    });
  }

  Widget _selectDateEnd() {
    return ListTile(
      onTap: () {
        DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          minTime: DateTime(2000, 01, 01),
          maxTime: DateTime(2025, 12, 30),
          locale: LocaleType.vi,
          currentTime: DateTime.now(),
          onConfirm: (date) {
            setState(() {
              dateEnd = DateFormat('yyyy-MM-dd').format(date);
            });
          },
          onCancel: () {
            setState(() {});
          },
        );
      },
      dense: false,
      visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
      leading: const Icon(
        Icons.calendar_month,
        size: 30,
        color: Colors.grey,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ngày kêt thúc',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.withOpacity(0.4),
            ),
          ),
          Text(
            dateEnd ?? 'Không xác định',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }
}
