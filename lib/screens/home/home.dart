import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:viet_wallet/network/model/data_sfcartesian_char_model.dart';
import 'package:viet_wallet/routes.dart';
import 'package:viet_wallet/screens/home/home_bloc.dart';
import 'package:viet_wallet/screens/home/home_event.dart';
import 'package:viet_wallet/screens/home/home_state.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';

import '../../network/model/wallet.dart';
import '../../network/model/week_report_model.dart';
import '../../utilities/screen_utilities.dart';
import '../../utilities/utils.dart';
import '../my_wallet/wallet_details/wallet_details.dart';
import '../my_wallet/wallet_details/wallet_details_bloc.dart';
import 'expenditure_report/expenditure_report.dart';
import 'revenue_report/revenue_report.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _isShowBalance = SharedPreferencesStorage().getHiddenAmount();
  int notificationBadge = 3;

  late HomePageBloc _homePageBloc;

  late TabController _tabController;

  final String currency = SharedPreferencesStorage().getCurrency();

  bool _showDetail = true;

  void _reloadPage() {
    // showLoading(context);
    _homePageBloc.add(HomeInitial());
    Future.delayed(const Duration(milliseconds: 1500), () {
      // Navigator.pop(context);
      setState(() {});
    });
  }

  @override
  void initState() {
    _homePageBloc = BlocProvider.of<HomePageBloc>(context)..add(HomeInitial());
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _homePageBloc.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, curState) {
        if (curState.apiError == ApiError.internalServerError) {
          showMessage1OptionDialog(
            context,
            'Error!',
            content: 'Internal_server_error',
          );
        }
        if (curState.apiError == ApiError.noInternetConnection) {
          showMessageNoInternetDialog(context);
        }
      },
      builder: (context, curState) {
        return _body(context, curState);
      },
    );
  }

  Widget _body(BuildContext context, HomePageState state) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: state.isLoading
          ? const AnimationLoading()
          : RefreshIndicator(
              onRefresh: () async => _reloadPage(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _balance((state.moneyTotal ?? 0).toDouble()),
                      _myWallet(state.listWallet),
                      _reportWeek(state.weekReport),
                      _expenseReport(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _reportWeek(WeekReportModel? report) {
    final List<DataSf> chartData = report?.detailReport ?? [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: SizedBox(
        height: _showDetail ? 400 + 40 * (chartData.length).toDouble() : 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Báo cáo chi tiêu theo tuần',
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10.0),
                      child: Text(
                        '(Đơn vị: triệu VNĐ)',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                    SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<DataSf, String>>[
                        ColumnSeries<DataSf, String>(
                          dataSource: chartData,
                          xValueMapper: (DataSf data, _) => data.title,
                          yValueMapper: (DataSf data, _) =>
                              data.value / 1000000,
                          name: 'Báo cáo tuần',
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          ),
                        )
                      ],
                    ),
                    listDetails(chartData),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expenseReport() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        height: 550,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Báo cáo tỉ lệ chi tiêu theo hạng mục',
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            unselectedLabelColor: Colors.grey[500],
                            labelColor: Colors.black,
                            labelStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            padding: const EdgeInsets.all(2),
                            indicatorWeight: 1.5,
                            indicatorColor: Colors.black,
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            tabs: const [
                              Tab(text: 'Hạng mục chi'),
                              Tab(text: 'Hạng mục thu'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: const [
                            ExpenditureReport(),
                            RevenueReport(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myWallet(List<Wallet>? listWallet) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: SizedBox(
                height: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ví của tôi',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.myWallet);
                      },
                      child: Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Divider(height: 1, color: Colors.grey),
            ),
            isNullOrEmpty(listWallet)
                ? Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: Text(
                      'Bạn chưa có tài khoản/ví.\nVui lòng tạo mới tài khoản/ví.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 60 * (listWallet!.length).toDouble() + 15,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listWallet.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {}
                        return _createItemWallet(
                          context,
                          listWallet[index],
                          thisIndex: index,
                          endIndex: listWallet.length,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _balance(double balance) {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng số dư ',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: Text(
                        _isShowBalance
                            ? '${formatterDouble(balance)}  $currency'
                            : '******  $currency',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            _isShowBalance = !_isShowBalance;
                          });
                          await SharedPreferencesStorage()
                              .setHiddenAmount(_isShowBalance);
                        },
                        child: Icon(
                          _isShowBalance
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 26,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Badge(
                showBadge: (notificationBadge > 0),
                badgeContent: Text((notificationBadge.toString()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                badgeStyle: const BadgeStyle(
                  badgeColor: Colors.red,
                  padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                ),
                position: BadgePosition.topEnd(top: -3, end: -3),
                child: const Icon(
                  Icons.notifications,
                  size: 26,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createItemWallet(
    BuildContext context,
    Wallet wallet, {
    required int thisIndex,
    required int endIndex,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => WalletDetailsBloc(context),
              child: WalletDetails(wallet: wallet),
            ),
          ),
        );
      },
      child: Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular((thisIndex == endIndex) ? 15 : 0),
            bottomRight: Radius.circular((thisIndex == endIndex) ? 15 : 0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  isNotNullOrEmpty(wallet.accountType)
                      ? getIconWallet(walletType: wallet.accountType ?? '')
                      : Icons.help_outline,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: Text(
                '${wallet.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 16),
              child: Text(
                _isShowBalance
                    ? '${formatterDouble((wallet.accountBalance ?? 0).toDouble())} $currency'
                    : '****** $currency',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listDetails(List<DataSf>? listReport) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _showDetail = !_showDetail;
              });
            },
            child: SizedBox(
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    _showDetail
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (_showDetail)
            SizedBox(
              height: 40 * (listReport!.length).toDouble(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listReport.length,
                itemBuilder: (context, index) => details(listReport[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget details(DataSf report) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.2)),
            bottom: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.2)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              report.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Text(
              '${formatterDouble(report.value)} VND',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
