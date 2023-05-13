import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:viet_wallet/screens/planning/balance_payments/payments.position.bloc.dart';
import 'package:viet_wallet/screens/planning/balance_payments/payments.position.event.dart';
import 'package:viet_wallet/screens/planning/balance_payments/payments.position.state.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

import '../../../utilities/screen_utilities.dart';

class PaymentPosition extends StatefulWidget {
  const PaymentPosition({Key? key}) : super(key: key);

  @override
  State<PaymentPosition> createState() => _PaymentPositionState();
}

class _PaymentPositionState extends State<PaymentPosition>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    BlocProvider.of<PaymentsPositionBloc>(context).add(PaymentsPositionInit());
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  List<_SalesData> data = [
    _SalesData('july', 1128),
    _SalesData('may', 800),
    _SalesData('april', 900),
    _SalesData('june', 500),
    _SalesData('october', 200),
    _SalesData('december', 1000),
  ];

  List<_SalesData> datas = [
    _SalesData('july', -1128),
    _SalesData('may', 1128),
    _SalesData('april', -1128),
    _SalesData('june', -1128),
    _SalesData('october', 1128),
    _SalesData('december', 1128),
  ];

  List<_SalesData> dataPrecious = [
    _SalesData('Quý 1', 500),
    _SalesData('Quý 2', 1128),
  ];

  List<_SalesData> dataPrecious2 = [
    _SalesData('Quý 1', -1128),
    _SalesData('Quý 2', -500),
  ];

  List<_SalesData> dataYear = [
    _SalesData('2023', 500),
  ];

  List<_SalesData> dataYear2 = [
    _SalesData('2023', -1128),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.white,
            )),
        title: const Text(
          'Tình hình thu chi',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
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
                Tab(text: 'Hiện tại'),
                Tab(text: 'Tháng'),
                Tab(text: 'Quý'),
                Tab(text: 'Năm'),
              ],
            ),
          ),
          barDialog('2023', context),
          const Divider(
            color: Colors.black,
            height: 1,
          ),
          Expanded(
            child: BlocConsumer<PaymentsPositionBloc, PaymentsPositionState>(
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
                // if (state.isLoading) {
                //   return const AnimationLoading();
                // }
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _all('Tháng này', '0', '01922128', '9217271'),
                    _chartsMonth(),
                    _chartsPrecious(),
                    _chartsYear()
                    // _expenditureTab(state.listExCategory), //expense
                    // _collectedTab(state.listCoCategory), //income
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _toDay(String? tittle, String? interest, String? loss, String origin) {
    return SingleChildScrollView(
      child: Container(
        height: 100,
        width: 100,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(10), right: Radius.circular(10))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tittle ?? '',
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$interest ₫' ?? "" + ' ₫',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.lightGreen),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$loss' + ' ₫',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.red),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$origin ₫',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _all(String? tittle, String? interest, String? loss, String origin) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
          height: 150,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(10), right: Radius.circular(10))),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tittle ?? '',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$interest ₫' ?? "" + ' ₫',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.lightGreen),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$loss' + ' ₫',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.red),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$origin ₫',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(
          color: Colors.black,
          height: 1,
        ),
        Container(
          height: 150,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(10), right: Radius.circular(10))),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quý này',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$interest ₫' ?? "" + ' ₫',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.lightGreen),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$loss' + ' ₫',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.red),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$origin ₫',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(
          color: Colors.black,
          height: 1,
        ),
        Container(
          height: 150,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(10), right: Radius.circular(10))),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Năm nay',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$interest ₫' ?? "" + ' ₫',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.lightGreen),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$loss' + ' ₫',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.red),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$origin ₫',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }

  Widget _chartsMonth() {
    return Padding(
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
                dataSource: data,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                color: Colors.grey,
                // Enable data label
                // dataLabelSettings: DataLabelSettings(isVisible: true)
              ),
              ColumnSeries<_SalesData, String>(
                dataSource: data,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                color: Colors.blue,
                // Enable data label
                // dataLabelSettings: DataLabelSettings(isVisible: true)
              ),
              ColumnSeries<_SalesData, String>(
                dataSource: datas,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                color: Colors.red,
                // Enable data label
                // dataLabelSettings: DataLabelSettings(isVisible: true)
              )
            ]),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            //Initialize the spark charts widget
            child: _all('Tháng này', '0', '01922128', '9217271'),
          ),
        )
      ]),
    );
  }

  Widget _chartsPrecious() {
    return Padding(
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
                dataSource: dataPrecious,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                color: Colors.grey,
                // Enable data label
                // dataLabelSettings: DataLabelSettings(isVisible: true)
              ),
              ColumnSeries<_SalesData, String>(
                dataSource: dataPrecious2,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                color: Colors.red,
                // Enable data label
                // dataLabelSettings: DataLabelSettings(isVisible: true)
              )
            ]),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            //Initialize the spark charts widget
            child: _all('Tháng này', '0', '01922128', '9217271'),
          ),
        )
      ]),
    );
  }

  Widget _chartsYear() {
    return Padding(
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
                color: Colors.grey,
                // Enable data label
                // dataLabelSettings: DataLabelSettings(isVisible: true)
              ),
              ColumnSeries<_SalesData, String>(
                dataSource: dataYear2,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                color: Colors.red,
                // Enable data label
                // dataLabelSettings: DataLabelSettings(isVisible: true)
              )
            ]),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            //Initialize the spark charts widget
            child: _all('Tháng này', '0', '01922128', '9217271'),
          ),
        )
      ]),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

Widget barDialog(String? year, BuildContext context) {
  return Container(
    height: 50,
    decoration: BoxDecoration(color: Colors.white),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.calendar_month),
            label: Text(year ?? '2023')),
        IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => _buildOptionDialog2(context),
              );
            },
            icon: Icon(Icons.settings))
      ],
    ),
  );
}

class ItemList {
  final String title;

  ItemList({
    required this.title,
  });
}

List<ItemList> itemOption = [
  ItemList(title: 'Item 1'),
  ItemList(title: 'Thu tiền'),
  ItemList(title: 'Cho vay'),
  ItemList(title: 'Đi vay'),
  ItemList(title: 'Chuyển khoản'),
  ItemList(title: 'Điều chỉnh số dư'),
];

Widget _buildOptionDialog2(BuildContext context) {
  return AlertDialog(
      title: Container(
        height: 40,
        width: double.infinity,
        color: Colors.blue,
        child: Center(
            child: Text(
          'Chọn năm',
          style: TextStyle(color: Colors.white),
        )),
      ),
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(8),
      content: Container(
        height: 300,
        width: 330,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: PageView.builder(
            itemCount: (itemOption.length / 3).ceil(),
            // Calculate the number of pages
            itemBuilder: (BuildContext context, int pageIndex) {
              final startIndex = pageIndex * 3;
              final endIndex = (startIndex + 3).clamp(0, itemOption.length);
              final pageItems = itemOption.sublist(startIndex, endIndex);
              return ListView.builder(
                itemCount: itemOption.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            itemOption[index].title,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ));
                },
              );
            }),
      ));
}
