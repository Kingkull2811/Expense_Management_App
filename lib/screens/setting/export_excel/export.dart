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
import '../limit_expenditure/limit_info/select_wallets.dart';
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

  List<Wallet> listWalletSelected = [];

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
            return const AnimationLoading();
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
        _selectWallets(listWallet),
        Divider(
          height: 0.5,
          color: Colors.grey.withOpacity(0.3),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: PrimaryButton(
            text: 'Xuất file',
            onTap: () {
              if (isNullOrEmpty(dateEnd)) {
                showMessage1OptionDialog(
                  context,
                  'Vui lòng chọn ngày kết thúc trước khi xuất file',
                );
              } else if (isNullOrEmpty(listWalletSelected)) {
                showMessage1OptionDialog(
                  context,
                  'Vui lòng chọn tài khoản/ví trước khi xuất file',
                );
              } else {
                List<int> walletIDs = [];
                listWalletSelected.map((e) => walletIDs.add(e.id!)).toList();
                _exportBloc.add(GetExport(
                  walletIDs: walletIDs,
                  formDate: dateStart,
                  toDate: dateEnd,
                ));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _selectWallets(List<Wallet>? listWallet) {
    List<Wallet> listWalled = listWallet ?? [];
    List<String> titles =
        listWalled.map((wallet) => wallet.name ?? '').toList();
    String walletsName = titles.join(', ');

    return ListTile(
      onTap: () async {
        final List<Wallet>? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectWalletsPage(
              listWallet: listWalled,
            ),
          ),
        );
        setState(() {
          listWalletSelected = result ?? [];
        });
      },
      dense: false,
      horizontalTitleGap: 10,
      leading: const Icon(
        Icons.wallet,
        size: 30,
        color: Colors.grey,
      ),
      title: Text(
        isNullOrEmpty(listWalletSelected)
            ? 'Chọn tài khoản/ví'
            : listWalletSelected.length == listWallet?.length
                ? 'Tất cả tài khoản'
                : walletsName,
        style: TextStyle(
          fontSize: 16,
          color: isNullOrEmpty(listWalletSelected) ? Colors.grey : Colors.black,
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
