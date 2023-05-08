import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:viet_wallet/network/model/collection_model.dart';
import 'package:viet_wallet/screens/my_wallet/wallet_details/wallet_details_bloc.dart';
import 'package:viet_wallet/screens/my_wallet/wallet_details/wallet_details_event.dart';
import 'package:viet_wallet/screens/my_wallet/wallet_details/wallet_details_state.dart';
import 'package:viet_wallet/screens/new_collection/new_collection.dart';
import 'package:viet_wallet/screens/new_collection/new_collection_bloc.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';
import 'package:viet_wallet/utilities/utils.dart';
import 'package:viet_wallet/widgets/app_image.dart';

import '../../../network/model/day_transcaction_model.dart';
import '../../../network/model/wallet.dart';
import '../../../network/model/wallet_report_model.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import '../../new_collection/new_collection_event.dart';

class WalletDetails extends StatefulWidget {
  final Wallet wallet;

  const WalletDetails({Key? key, required this.wallet}) : super(key: key);

  @override
  State<WalletDetails> createState() => _WalletDetailsState();
}

class _WalletDetailsState extends State<WalletDetails> {
  late WalletDetailsBloc _walletDetailsBloc;

  final String currency = SharedPreferencesStorage().getCurrency() ?? '\$/USD';

  String toDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String fromDate = DateFormat('yyyy-MM-dd').format(DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day));

  @override
  void initState() {
    _walletDetailsBloc = BlocProvider.of<WalletDetailsBloc>(context)
      ..add(WalletDetailInit(walletId: widget.wallet.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletDetailsBloc, WalletDetailsState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, curState) {
        if (curState.apiError == ApiError.internalServerError) {
          showMessage1OptionDialog(context, 'Error!',
              content: 'Internal_server_error');
        }
        if (curState.apiError == ApiError.noInternetConnection) {
          showMessage1OptionDialog(context, 'Error!',
              content: 'No_internet_connection');
        }
      },
      builder: (context, curState) {
        return _body(context, curState.walletReport);
      },
    );
  }

  Widget _body(BuildContext context, WalletReport? walletReport) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Theme.of(context).primaryColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.wallet.name ?? '',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _timeReport(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Tổng thu',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            '${walletReport?.incomeTotal} $currency',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, color: Colors.grey),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Tổng chi',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            '${walletReport?.expenseTotal} $currency',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Số dư hiện tại',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${walletReport?.currentBalance} $currency',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: _infoReport(context, walletReport?.dayTransactionList))
        ],
      ),
    );
  }

  Widget _timeReport() {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Thời gian',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _time(title: 'Từ', isFrom: true),
                  _time(title: 'Đến', isFrom: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _time({
    String? title,
    bool isFrom = false,
  }) {
    return Expanded(
      child: Row(
        children: [
          Text('$title: '),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isFrom ? 10 : 0),
              child: InkWell(
                onTap: () {
                  DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(2000, 01, 01),
                    maxTime: DateTime(2025, 12, 30),
                    locale: LocaleType.vi,
                    currentTime: isFrom
                        ? DateTime(
                            DateTime.now().year,
                            DateTime.now().month - 1,
                            DateTime.now().day,
                          )
                        : DateTime.now(),
                    onConfirm: (date) {
                      setState(() {
                        isFrom
                            ? fromDate = DateFormat('yyyy-MM-dd').format(date)
                            : toDate = DateFormat('yyyy-MM-dd').format(date);
                      });
                    },
                    onCancel: () {
                      setState(() {});
                    },
                  ).whenComplete(() {
                    _walletDetailsBloc.add(WalletDetailInit(
                      walletId: widget.wallet.id,
                      fromDate: fromDate,
                      toDate: toDate,
                    ));
                    setState(() {});
                  });
                },
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(isFrom ? fromDate : toDate),
                        ),
                      ),
                      Icon(
                        Icons.expand_more,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoReport(
    BuildContext context,
    List<DayTransaction>? listDayTransaction,
  ) {
    return SizedBox(
      child: isNotNullOrEmpty(listDayTransaction)
          ? ListView.builder(
              itemCount: listDayTransaction!.length,
              itemBuilder: (context, index) =>
                  _createItemReport(context, listDayTransaction[index]),
            )
          : Center(
              child: Text(
                'Chưa có ghi chép chi tiêu nào',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
    );
  }

  Widget _createItemReport(
    BuildContext context,
    DayTransaction? dayTransaction,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${dayTransaction?.date}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text('${dayTransaction?.amountTotal} $currency'),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            if (isNotNullOrEmpty(dayTransaction?.transactionOutputs))
              SizedBox(
                height: 60 *
                    (dayTransaction?.transactionOutputs!.length ?? 1)
                        .toDouble(),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dayTransaction?.transactionOutputs!.length,
                  itemBuilder: (context, index) => _createItemTransaction(
                      context, dayTransaction?.transactionOutputs![index]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _createItemTransaction(
    BuildContext context,
    CollectionModel? collectionInfo,
  ) {
    final isExpense = collectionInfo?.transactionType == 'EXPENSE';
    if (isNullOrEmpty(collectionInfo)) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 60,
      child: ListTile(
        onTap: () async {
          final String result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) =>
                    NewCollectionBloc(context)..add(CollectionInit()),
                child: NewCollectionPage(
                  isEdit: true,
                  collectionReport: collectionInfo,
                ),
              ),
            ),
          );
          if (result == 'refresh') {
            _walletDetailsBloc
                .add(WalletDetailInit(walletId: widget.wallet.id));
            setState(() {});
          }
        },
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withOpacity(0.2),
            ),
            child: AppImage(
              localPathOrUrl: collectionInfo?.categoryLogo,
              errorWidget: const Icon(
                Icons.help_outline,
                size: 30,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        title: Text(
          '${collectionInfo?.categoryName}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        trailing: Text(
          '${collectionInfo?.amount} $currency',
          style: TextStyle(
            fontSize: 16,
            color:
                isExpense ? Colors.redAccent : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
