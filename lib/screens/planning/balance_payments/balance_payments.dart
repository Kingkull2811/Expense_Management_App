import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../network/model/wallet.dart';
import '../../../utilities/utils.dart';
import '../../setting/limit_expenditure/limit_info/select_wallets.dart';

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

  List<int> initWallet(List<Wallet>? wallets) {
    List<int> walletIDs = [];
    for (var element in wallets ?? []) {
      walletIDs.add(element.id!);
    }
    return walletIDs;
  }

  @override
  void initState() {
    // BlocProvider.of<PaymentsPositionBloc>(context).add(PaymentsPositionInit());
    _tabController = TabController(length: 5, vsync: this);
    listWalletSelected = widget.listWallet ?? [];
    walletIDs = initWallet(widget.listWallet);
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
                _all('Tháng này', '0', '01922128', '9217271'),
                _chartsMonth(),
                _chartsPrecious(),
                _chartsYear(),
              ],
            ),
          ),
        ],
      ),
      // body: Column(
      //   children: [
      //     barDialog('2023', context),
      //     const Divider(
      //       color: Colors.black,
      //       height: 1,
      //     ),
      //     Expanded(
      //       child: BlocConsumer<PaymentsPositionBloc, PaymentsPositionState>(
      //         listenWhen: (preState, curState) {
      //           return curState.apiError != ApiError.noError;
      //         },
      //         listener: (context, state) {
      //           if (state.apiError == ApiError.internalServerError) {
      //             showMessage1OptionDialog(
      //               context,
      //               'Error!',
      //               content: 'Internal_server_error',
      //             );
      //           }
      //           if (state.apiError == ApiError.noInternetConnection) {
      //             showMessageNoInternetDialog(context);
      //           }
      //         },
      //         builder: (context, state) {
      //           // if (state.isLoading) {
      //           //   return const AnimationLoading();
      //           // }
      //         },
      //       ),
      //     ),
      //   ],
      // ),
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
        Divider(
          height: 10,
          thickness: 10,
          color: Theme.of(context).backgroundColor,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Initialize the chart widget
                const Text(
                  '(Đơn vị: VNĐ)',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
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
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    //Initialize the spark charts widget
                    child: _all('Tháng này', '0', '01922128', '9217271'),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
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
