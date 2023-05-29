import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/day_analytic/day_analytic_bloc.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/day_analytic/day_analytic_event.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/day_analytic/day_analytic_state.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';

import '../../../../network/model/category_model.dart';
import '../../../../network/model/wallet.dart';
import '../../../../utilities/enum/api_error_result.dart';
import '../../../../utilities/screen_utilities.dart';
import '../../../../utilities/utils.dart';
import '../../../setting/limit_expenditure/limit_info/select_category.dart';
import '../../../setting/limit_expenditure/limit_info/select_wallets.dart';

class DayAnalytic extends StatefulWidget {
  final List<Wallet>? listWallet;
  final List<CategoryModel>? listCate;

  const DayAnalytic({
    Key? key,
    this.listWallet,
    this.listCate,
  }) : super(key: key);

  @override
  State<DayAnalytic> createState() => _DayAnalyticState();
}

class _DayAnalyticState extends State<DayAnalytic> {
  List<Wallet> listWalletSelected = [];
  List<int> listCateIDSelected = [];
  List<int> listCategoryId = [];

  String firstDayOfMonth = DateFormat('yyyy/MM/dd')
      .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
  String lastDayOfMonth = DateFormat('yyyy/MM/dd')
      .format(DateTime(DateTime.now().year, DateTime.now().month + 1, 0));

  List<int> initCate(List<CategoryModel>? list) {
    List<int> listCateId = [];
    for (CategoryModel category in list ?? []) {
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

  late DayAnalyticBloc _analyticBloc;

  @override
  void initState() {
    listWalletSelected = widget.listWallet ?? [];
    listCateIDSelected = initCate(widget.listCate);
    _analyticBloc = BlocProvider.of<DayAnalyticBloc>(context)
      ..add(DayAnalyticEvent(
        fromDate: firstDayOfMonth,
        toDate: lastDayOfMonth,
        walletIDs: initWallet(widget.listWallet),
        categoryIDs: initCate(widget.listCate),
      ));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _analyticBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DayAnalyticBloc, DayAnalyticState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, state) {
        if (state.apiError == ApiError.internalServerError) {
          showMessage1OptionDialog(
            context,
            'Error!',
            content: 'Internal_server_error',
          );
        }
        if (state.apiError == ApiError.noInternetConnection) {
          showMessageNoInternetDialog(context);
        }
      },
      builder: (context, state) {
        return state.isLoading
            ? const AnimationLoading()
            : _body(context, state);
      },
    );
  }

  Widget _body(BuildContext context, DayAnalyticState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _selectDay(),
            Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
            _selectCategory(),
            Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
            _selectWallet(),
            Divider(
              color: Colors.grey.withOpacity(0.2),
              height: 10,
              thickness: 10,
            ),
            //Initialize the chart widget
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                '(Đơn vị: VNĐ)',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            // SfCartesianChart(
            //     primaryXAxis: CategoryAxis(),
            //     tooltipBehavior: TooltipBehavior(enable: false),
            //     series: <ChartSeries<_SalesData, String>>[
            //       LineSeries<_SalesData, String>(
            //         dataSource: dataDay,
            //         xValueMapper: (_SalesData sales, _) => sales.year,
            //         yValueMapper: (_SalesData sales, _) => sales.sales,
            //         name: 'Sales',
            //         color: Colors.lightBlueAccent,
            //       ),
            //     ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Tổng chi tiêu',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Colors.grey),
                  ),
                  Text(
                    '1.291.918.123.343 đ',
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Trung bình chỉ/ngày',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '21.918.123 đ',
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Divider(
              color: Colors.grey.withOpacity(0.2),
              height: 10,
              thickness: 1,
            ),
            const SizedBox(height: 5),
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

  Widget _selectDay() {
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
                Icons.calendar_today,
                size: 30,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: Text(
                '$firstDayOfMonth -> $lastDayOfMonth',
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
    List<CategoryModel> listCate = widget.listCate ?? [];
    listCate.forEach(updateCheckedStatusCategory);
    List<int> listCateID = initCate(listCate);

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
            // listCategoryId = listCateID;
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
        (listCateIDSelected.length == listCateID.length)
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
}
