import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/day_analytic/day_analytic.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/day_analytic/day_analytic_bloc.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/month_analytic/month_analytic.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/month_analytic/month_analytic_bloc.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/month_analytic/month_analytic_event.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/year_analytic/year_analytic.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/year_analytic/year_analytic_bloc.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/year_analytic/year_analytic_event.dart';
import 'package:viet_wallet/utilities/screen_utilities.dart';

import '../../../network/model/category_model.dart';
import '../../../network/model/wallet.dart';
import '../../../utilities/utils.dart';
import '../../setting/limit_expenditure/limit_info/select_category.dart';
import '../../setting/limit_expenditure/limit_info/select_wallets.dart';
import 'day_analytic/day_analytic_event.dart';

class Expenditure extends StatefulWidget {
  final List<Wallet>? listWallet;
  final List<CategoryModel>? listCategory;

  const Expenditure({
    Key? key,
    this.listWallet,
    this.listCategory,
  }) : super(key: key);

  @override
  State<Expenditure> createState() => _ExpenditureState();
}

class _ExpenditureState extends State<Expenditure>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  ///analytic year
  String fromYear = '2018';
  String endYear = '2025';

  ///analytic Month
  String fromMonth =
      DateFormat('yyyy-MM').format(DateTime(DateTime.now().year, 1));
  String endMonth =
      DateFormat('yyyy-MM').format(DateTime(DateTime.now().year, 12));

  ///analytic Day
  String firstDayOfMonth = DateFormat('yyyy-MM-dd')
      .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
  String lastDayOfMonth = DateFormat('yyyy-MM-dd')
      .format(DateTime(DateTime.now().year, DateTime.now().month + 1, 0));

  List<int> initEXCate(List<CategoryModel>? listCate) {
    List<int> listCateId = [];
    for (CategoryModel category in listCate ?? []) {
      if (category.childCategory != null) {
        for (CategoryModel childCategory in category.childCategory!) {
          listCateId.add(childCategory.id!);
        }
      }
      listCateId.add(category.id!);
    }
    return listCateId;
  }

  List<int> initWallet(List<Wallet>? wallets) {
    List<int> walletIDs = [];
    for (var element in wallets ?? []) {
      walletIDs.add(element.id!);
    }
    return walletIDs;
  }

  List<int> listCateIDSelected = [];
  List<Wallet> listWalletSelected = [];
  List<int> listCategoryId = [];
  List<int> walletIDs = [];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    listWalletSelected = widget.listWallet ?? [];
    walletIDs = initWallet(widget.listWallet);
    listCateIDSelected = initEXCate(widget.listCategory);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'Phân tích chi tiêu',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
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
            tabs: const [
              Tab(text: 'NGÀY'),
              Tab(text: 'THÁNG'),
              Tab(text: 'NĂM'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _chartDayTab(),
            _chartsMonth(),
            _chartsYear(),
          ],
        ),
      ),
    );
  }

  Widget _chartDayTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _selectDayTime(context),
            Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
            _selectCategory(),
            Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
            _selectWallet(),
            Divider(
              color: Colors.grey.withOpacity(0.2),
              height: 10,
              thickness: 10,
            ),
            BlocProvider(
              create: (context) => DayAnalyticBloc(context)
                ..add(DayAnalyticEvent(
                  walletIDs: walletIDs,
                  categoryIDs: listCateIDSelected,
                  fromDate: firstDayOfMonth,
                  toDate: lastDayOfMonth,
                )),
              child: DayAnalytic(
                walletIDs: walletIDs,
                categoryIDs: listCateIDSelected,
                fromDate: firstDayOfMonth,
                toDate: lastDayOfMonth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartsMonth() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _selectMonthTime(),
            Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
            _selectCategory(),
            Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
            _selectWallet(),
            Divider(
              color: Colors.grey.withOpacity(0.2),
              height: 10,
              thickness: 10,
            ),
            BlocProvider(
              create: (context) => MonthAnalyticBloc(context)
                ..add(MonthAnalyticEvent(
                  walletIDs: walletIDs,
                  categoryIDs: listCateIDSelected,
                  fromMonth: fromMonth,
                  toMonth: endMonth,
                )),
              child: MonthAnalytic(
                walletIDs: walletIDs,
                categoryIDs: listCateIDSelected,
                fromMonth: fromMonth,
                toMonth: endMonth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartsYear() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _selectYearTime(),
            Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
            _selectCategory(),
            Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
            _selectWallet(),
            Divider(
              color: Colors.grey.withOpacity(0.2),
              height: 10,
              thickness: 10,
            ),
            BlocProvider(
              create: (context) => YearAnalyticBloc(context)
                ..add(YearAnalyticEvent(
                  walletIDs: walletIDs,
                  categoryIDs: listCateIDSelected,
                  fromYear: fromYear,
                  toYear: endYear,
                )),
              child: YearAnalytic(
                walletIDs: walletIDs,
                categoryIDs: listCateIDSelected,
                fromYear: fromYear,
                toYear: endYear,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateCheckedStatusCategory(CategoryModel category) {
    final List<int> listCategoryId = listCateIDSelected;

    if (listCategoryId.contains(category.id)) {
      category.isChecked = true;
    }
    category.childCategory?.forEach(updateCheckedStatusCategory);
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
                  InkWell(
                    onTap: () async {
                      final DateTime? timePick =
                          await _pickDayTime(firstDayOfMonth);
                      if (timePick == null) {
                        return;
                      } else if (DateTime.parse(firstDayOfMonth)
                          .isAfter(timePick)) {
                        showMessage1OptionDialog(this.context,
                            'Vui lòng chọn thời gian kết thúc sau thời gian bắt đâu.');
                      } else {
                        firstDayOfMonth =
                            DateFormat('yyyy/MM/dd').format(timePick);
                      }
                    },
                    child: Text(
                      'Từ: $firstDayOfMonth',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: InkWell(
                      onTap: () async {
                        final DateTime? timePick =
                            await _pickDayTime(lastDayOfMonth);
                        if (timePick == null) {
                          return;
                        } else {
                          lastDayOfMonth =
                              DateFormat('yyyy/MM/dd').format(timePick);
                        }
                      },
                      child: Text(
                        'Đến: $lastDayOfMonth',
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

  Widget _selectMonthTime() {
    return InkWell(
      onTap: () {},
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
                InkWell(
                  onTap: () async {
                    final DateTime? timePick = await _pickMonth(fromMonth);
                    if (timePick == null) {
                      return;
                    } else if (DateTime.parse(fromMonth).isAfter(timePick)) {
                      showMessage1OptionDialog(this.context,
                          'Vui lòng chọn thời gian kết thúc sau thời gian bắt đâu.');
                    } else {
                      fromMonth = DateFormat('yyyy/MM').format(timePick);
                    }
                  },
                  child: Text(
                    'Từ: $fromMonth',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: InkWell(
                    onTap: () async {
                      final DateTime? timePick = await _pickMonth(endMonth);
                      if (timePick == null) {
                        return;
                      } else {
                        endMonth = DateFormat('yyyy/MM').format(timePick);
                      }
                    },
                    child: Text(
                      'Đến: $endMonth',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            )),
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

  Widget _selectYearTime() {
    return InkWell(
      onTap: () {},
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
              child: Text(
                '$fromYear -> $endYear',
                style: const TextStyle(fontSize: 14, color: Colors.black),
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

  Widget _selectCategory() {
    List<CategoryModel> listCate = widget.listCategory ?? [];
    listCate.forEach(updateCheckedStatusCategory);
    List<int> listCateIDs = [];
    for (CategoryModel category in widget.listCategory ?? []) {
      if (category.childCategory != null) {
        for (CategoryModel childCategory in category.childCategory!) {
          listCateIDs.add(childCategory.id!);
        }
      }
      listCateIDs.add(category.id!);
    }

    return ListTile(
      onTap: () async {
        final List<int>? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectCategory(
              listCategory: listCate,
            ),
          ),
        );
        if (isNotNullOrEmpty(result)) {
          setState(() {
            listCateIDSelected = result ?? [];
          });
        } else {
          return;
        }
      },
      dense: false,
      horizontalTitleGap: 10,
      leading: const Icon(
        Icons.category_outlined,
        size: 30,
        color: Colors.grey,
      ),
      title: Text(
        (listCateIDSelected.length == listCateIDs.length)
            ? 'Tất cả hạng mục'
            : isNullOrEmpty(listCateIDSelected)
                ? 'Chọn hạng mục'
                : '${listCateIDSelected.length} hạng mục',
        style: TextStyle(
          fontSize: 16,
          color:
              isNotNullOrEmpty(listCateIDSelected) ? Colors.black : Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
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

  Future<DateTime?> _pickDayTime(String current) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.parse(current),
      firstDate: DateTime(1990, 01, 01),
      lastDate: DateTime(2050, 12, 31),
    );
  }

  Future<DateTime?> _pickMonth(String current) async {
    await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990, 01, 01),
      lastDate: DateTime(2050, 12, 31),
    );
  }
}
