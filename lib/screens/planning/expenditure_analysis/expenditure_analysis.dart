import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/day_analytic/day_analytic.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/day_analytic/day_analytic_bloc.dart';

import '../../../network/model/category_model.dart';
import '../../../network/model/wallet.dart';

class Expenditure extends StatefulWidget {
  final List<Wallet>? listWallet;
  final List<CategoryModel>? listExCategory, listCoCategory;

  const Expenditure({
    Key? key,
    this.listWallet,
    this.listExCategory,
    this.listCoCategory,
  }) : super(key: key);

  @override
  State<Expenditure> createState() => _ExpenditureState();
}

class _ExpenditureState extends State<Expenditure>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  List<_SalesData> dataDay = [
    _SalesData('day 1', 1128),
    _SalesData('day 2', 800),
    _SalesData('day 3', 900),
    _SalesData('day 4', 500),
    _SalesData('day 5', 200),
    _SalesData('day 6', 1000),
    _SalesData('day 7', 1000),
  ];

  List<_SalesData> dataYear = [
    _SalesData('2018', 1128),
    _SalesData('2019', 800),
    _SalesData('2020', 900),
    _SalesData('2021', 500),
    _SalesData('2022', 200),
    _SalesData('2023', 1000),
  ];

  List<_SalesData> dataMonth = [
    _SalesData('1', 1128),
    _SalesData('2', 800),
    _SalesData('3', 900),
    _SalesData('4', 500),
    _SalesData('5', 200),
    _SalesData('6', 1000),
    _SalesData('7', 1128),
    _SalesData('8', 800),
    _SalesData('9', 900),
    _SalesData('10', 500),
    _SalesData('11', 200),
    _SalesData('12', 1000),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          color: Theme.of(context).primaryColor,
          child: TabBar(
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
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              BlocProvider(
                create: (context) => DayAnalyticBloc(context),
                child: DayAnalytic(
                  listCate: widget.listExCategory,
                  listWallet: widget.listWallet,
                ),
              ),
              _chartsMonth(),
              _chartsYear(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chartsYear() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //Initialize the chart widget
          const Text(
            '(Đơn vị: VNĐ)',
            style: TextStyle(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
          ),
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              // Enable legend
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                ColumnSeries<_SalesData, String>(
                  dataSource: dataYear,
                  xValueMapper: (_SalesData sales, _) => sales.year,
                  yValueMapper: (_SalesData sales, _) => sales.sales,
                  name: 'Sales',
                  color: Colors.lightBlue,
                ),
              ]),
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
                      color: Colors.grey),
                ),
                Text(
                  '21.918.123 đ',
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Divider(
            color: Colors.grey.withOpacity(0.2),
            height: 10,
            thickness: 1,
          ),
          SizedBox(height: 5),
          listFilter(true)
        ]),
      ),
    );
  }

  Widget _chartsMonth() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //Initialize the chart widget
          const Text(
            '(Đơn vị: VNĐ)',
            style: TextStyle(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
          ),
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              // Enable legend
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                ColumnSeries<_SalesData, String>(
                  dataSource: dataMonth,
                  xValueMapper: (_SalesData sales, _) => sales.year,
                  yValueMapper: (_SalesData sales, _) => sales.sales,
                  name: 'Sales',
                  color: Colors.lightBlue,
                ),
              ]),
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
                      color: Colors.grey),
                ),
                Text(
                  '21.918.123 đ',
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Divider(
            color: Colors.grey.withOpacity(0.2),
            height: 10,
            thickness: 1,
          ),
          SizedBox(height: 5),
          listFilter(true)
        ]),
      ),
    );
  }
}

Widget listFilter(bool? click) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Xem chi tiết',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            click == true
                ? const Icon(Icons.keyboard_arrow_up)
                : const Icon(Icons.keyboard_arrow_down)
          ],
        ),
        if (click == true)
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return details();
            },
          ),
      ],
    ),
  );
}

Widget details() {
  return Column(
    children: [
      SizedBox(height: 7),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '01/04/2023',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          Row(
            children: const [
              Text(
                '17.298.098 đ',
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(width: 5),
              Icon(Icons.keyboard_arrow_right_rounded)
            ],
          ),
        ],
      ),
      Divider(
        color: Colors.grey.withOpacity(0.2),
        height: 10,
        thickness: 1,
      ),
    ],
  );
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
