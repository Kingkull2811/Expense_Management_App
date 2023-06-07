import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:viet_wallet/screens/planning/balance_payments/current/current_bloc.dart';
import 'package:viet_wallet/screens/planning/balance_payments/current/current_event.dart';
import 'package:viet_wallet/screens/planning/balance_payments/custom/custom.dart';
import 'package:viet_wallet/screens/planning/balance_payments/month/month.dart';
import 'package:viet_wallet/screens/planning/balance_payments/month/month_bloc.dart';
import 'package:viet_wallet/screens/planning/balance_payments/month/month_event.dart';
import 'package:viet_wallet/screens/planning/balance_payments/precious/precious.dart';
import 'package:viet_wallet/screens/planning/balance_payments/precious/precious_bloc.dart';
import 'package:viet_wallet/screens/planning/balance_payments/precious/precious_event.dart';
import 'package:viet_wallet/screens/planning/balance_payments/year/year.dart';
import 'package:viet_wallet/screens/planning/balance_payments/year/year_bloc.dart';
import 'package:viet_wallet/screens/planning/balance_payments/year/year_event.dart';

import '../../../network/model/wallet.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../utilities/utils.dart';
import '../../setting/limit_expenditure/limit_info/select_wallets.dart';
import 'current/current.dart';
import 'custom/custom_bloc.dart';
import 'custom/custom_event.dart';

class BalancePayments extends StatefulWidget {
  final List<Wallet>? listWallet;

  const BalancePayments({Key? key, this.listWallet}) : super(key: key);

  @override
  State<BalancePayments> createState() => _BalancePaymentsState();
}

class _BalancePaymentsState extends State<BalancePayments>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Wallet> listWalletSelected = [];
  List<int> walletIDs = [];

  List<int> initWallet(List<Wallet> wallets) {
    return List.generate(wallets.length, (index) {
      return listWalletSelected[index].id!;
    });
  }

  int currentYear = DateTime.now().year;
  int toYear = DateTime.now().year + 2;
  String fromTime = DateFormat('yyyy-MM-dd')
      .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
  String toTime = DateFormat('yyyy-MM-dd')
      .format(DateTime(DateTime.now().year, DateTime.now().month + 1, 0));

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    listWalletSelected = widget.listWallet ?? [];
    walletIDs = initWallet(widget.listWallet ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Tình hình thu chi',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.white.withOpacity(0.2),
          labelColor: Colors.white,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          indicatorWeight: 2,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(text: 'HIỆN TẠI'),
            Tab(text: 'THÁNG'),
            Tab(text: 'QUÝ'),
            Tab(text: 'NĂM'),
            Tab(text: 'TÙY CHỌN'),
          ],
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 10,
            thickness: 10,
            color: Theme.of(context).backgroundColor,
          ),
          _selectWallet(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _current(),
                _chartsMonth(),
                _chartsPrecious(),
                _chartsYear(),
                _chartsCustom(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectWallet() {
    List<String> titles =
        listWalletSelected.map((wallet) => wallet.name ?? '').toList();
    String walletsName = titles.join(', ');

    return ListTile(
      onTap: () async {
        final List<Wallet>? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectWalletsPage(
              listWallet: widget.listWallet,
            ),
          ),
        );
        setState(() {
          listWalletSelected = result ?? [];
          walletIDs = initWallet(listWalletSelected);

          context.read<CurrentAnalyticBloc>().add(CurrentAnalyticEvent(
                walletIDs: walletIDs,
              ));

          context.read<MonthAnalyticBlocB>().add(MonthAnalyticEvent(
                walletIDs: walletIDs,
                year: currentYear,
              ));

          context.read<PreciousAnalyticBloc>().add(PreciousAnalyticEvent(
                walletIDs: walletIDs,
                year: currentYear,
              ));

          context.read<YearAnalyticBlocB>().add(YearAnalyticEvent(
                walletIDs: walletIDs,
                year: currentYear,
                toYear: toYear,
              ));

          context.read<CustomAnalyticBloc>().add(CustomAnalyticEvent(
                walletIDs: walletIDs,
                fromTime: fromTime,
                toTime: toTime,
              ));
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
            ? 'Chọn tài khoản'
            : listWalletSelected.length == widget.listWallet?.length
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

  Widget _current() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.3)),
            ),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 20),
                child: Icon(
                  Icons.calendar_month,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: Text(
                  'Năm hiện tại: ${DateTime.now().year}',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 10,
          thickness: 10,
          color: Theme.of(context).backgroundColor,
        ),
        Expanded(child: CurrentAnalytic(walletIDs: walletIDs)),
      ],
    );
  }

  Widget _chartsMonth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.3)),
            ),
          ),
          child: _selectYearTime(),
        ),
        Divider(
          height: 10,
          thickness: 10,
          color: Theme.of(context).backgroundColor,
        ),
        Expanded(
          child: MonthAnalytic(walletIDs: walletIDs, year: currentYear),
        ),
      ],
    );
  }

  Widget _chartsPrecious() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.3)),
            ),
          ),
          child: _selectYearTime(),
        ),
        Divider(
          height: 10,
          thickness: 10,
          color: Theme.of(context).backgroundColor,
        ),
        Expanded(
          child: PreciousAnalytic(year: currentYear, walletIDs: walletIDs),
        ),
      ],
    );
  }

  Widget _chartsYear() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.3)),
            ),
          ),
          child: _selectYearToYear(),
        ),
        Divider(
          height: 10,
          thickness: 10,
          color: Theme.of(context).backgroundColor,
        ),
        Expanded(
          child: YearAnalytic(
            walletIDs: walletIDs,
            year: currentYear,
            toYear: toYear,
          ),
        ),
      ],
    );
  }

  Widget _chartsCustom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.3)),
            ),
          ),
          child: _selectDayTime(context),
        ),
        Divider(
          height: 10,
          thickness: 10,
          color: Theme.of(context).backgroundColor,
        ),
        Expanded(
          child: CustomAnalytic(
            walletIDs: walletIDs,
            fromTime: fromTime,
            toTime: toTime,
          ),
        ),
      ],
    );
  }

  Widget _selectYearTime() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 20),
          child: Icon(
            Icons.calendar_month,
            size: 30,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Chọn năm'),
                  content: SizedBox(
                    height: 300,
                    width: 300,
                    child: YearPicker(
                      firstDate: DateTime(2010),
                      lastDate: DateTime(2040),
                      selectedDate: DateTime(currentYear),
                      onChanged: (DateTime valuer) {
                        setState(() {
                          currentYear = valuer.year;

                          this.context.read<MonthAnalyticBlocB>().add(
                                MonthAnalyticEvent(
                                  walletIDs: walletIDs,
                                  year: currentYear,
                                ),
                              );

                          this.context.read<PreciousAnalyticBloc>().add(
                                PreciousAnalyticEvent(
                                  year: currentYear,
                                  walletIDs: walletIDs,
                                ),
                              );
                        });
                        showLoading(context);
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {});
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                ),
              );
            },
            child: Text(
              'Năm hiện tại: $currentYear',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _selectYearToYear() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 20),
            child: Icon(
              Icons.calendar_month,
              size: 30,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Chọn năm bắt đầu'),
                          content: SizedBox(
                            height: 300,
                            width: 300,
                            child: YearPicker(
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2040),
                              selectedDate: DateTime(currentYear),
                              onChanged: (DateTime valuer) {
                                setState(() {
                                  currentYear = valuer.year;

                                  this.context.read<YearAnalyticBlocB>().add(
                                        YearAnalyticEvent(
                                          walletIDs: walletIDs,
                                          year: currentYear,
                                          toYear: toYear,
                                        ),
                                      );
                                });

                                showLoading(context);
                                Future.delayed(const Duration(seconds: 2), () {
                                  setState(() {});
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Từ: $currentYear',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Chọn năm kết thúc'),
                          content: SizedBox(
                            height: 300,
                            width: 300,
                            child: YearPicker(
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2040),
                              selectedDate: DateTime(toYear),
                              onChanged: (DateTime valuer) {
                                if (valuer.year < currentYear) {
                                  showMessage1OptionDialog(
                                    context,
                                    'Vui lòng chọn năm kết thúc sau năm bắt đầu',
                                  );
                                } else {
                                  setState(() {
                                    toYear = valuer.year;

                                    this.context.read<YearAnalyticBlocB>().add(
                                          YearAnalyticEvent(
                                            walletIDs: walletIDs,
                                            year: currentYear,
                                            toYear: toYear,
                                          ),
                                        );
                                  });
                                  showLoading(context);
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    setState(() {});
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Đến: $toYear',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectDayTime(BuildContext context) {
    return InkWell(
      child: SizedBox(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 20),
              child: Icon(
                Icons.calendar_month,
                size: 30,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final DateTime? timePick = await _pickDayTime(fromTime);
                        if (timePick == null) {
                          return;
                        }else {
                          fromTime = DateFormat('yyyy-MM-dd').format(timePick);
                          if (!mounted) {
                            return;
                          }
                          this.context.read<CustomAnalyticBloc>().add(
                                CustomAnalyticEvent(
                                  walletIDs: walletIDs,
                                  fromTime: fromTime,
                                  toTime: toTime,
                                ),
                              );
                          showLoading(context);
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {});
                            // Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Text(
                        'Từ: $fromTime',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final DateTime? timePick = await _pickDayTime(toTime);
                        if (timePick == null) {
                          return;
                        } else if (timePick.isBefore(DateTime.parse(fromTime))) {
                          showMessage1OptionDialog(this.context,
                              'Vui lòng chọn thời gian kết thúc sau thời gian bắt đâu.');
                        }  else {
                          toTime = DateFormat('yyyy-MM-dd').format(timePick);
                          if (!mounted) {
                            return;
                          }
                          this.context.read<CustomAnalyticBloc>().add(
                                CustomAnalyticEvent(
                                  walletIDs: walletIDs,
                                  fromTime: fromTime,
                                  toTime: toTime,
                                ),
                              );
                          showLoading(context);
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {});
                            // Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Text(
                        'Đến: $toTime',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pickDayTime(String current) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.parse(current),
      firstDate: DateTime(1990, 01, 01),
      lastDate: DateTime(2050, 12, 31),
    );
  }
}
