import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/home/home_bloc.dart';
import 'package:intl/intl.dart';
import 'package:viet_wallet/screens/home/report_month/report_month.dart';
import 'package:viet_wallet/screens/home/report_week/report_week.dart';
import 'package:viet_wallet/utilities/app_constants.dart';
import 'package:viet_wallet/utilities/secure_storage.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _isShowBalance = false;
  int notificationBadge = 3;
  double balance = 15150169.00;
  final formatter = NumberFormat("#,##0.00", "en_US");

  late HomePageBloc _homePageBloc;

  late TabController _tabController;

  Future<String>authenticationStatus()async {
    final SecureStorage secureStorage = SecureStorage();
    String accessToken = await secureStorage.readSecureData(
        AppConstants.accessTokenKey);
    print('accessToken: $accessToken');
    print('date now: ${DateTime.now().toIso8601String()}');
    if(DateTime.parse(accessToken).isAfter(DateTime.now())){
      print('accessToken has expired');
    }else{

      print('accessToken hasn\'t expired');
    }
    return accessToken;
  }
  @override
  void initState() {
    _homePageBloc = BlocProvider.of<HomePageBloc>(context);
    _tabController = TabController(length: 2, vsync: this);
    authenticationStatus();
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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _balance(),
            _myWallet(),
            _expenseReport(),
          ],
        ),
      ),
    );
  }

  Widget _expenseReport() {
    return SizedBox(
      height: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Báo cáo chi tiêu',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Xem báo cáo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            ],
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
                          padding:const EdgeInsets.all(2),
                          indicatorWeight: 1.5,
                          indicatorColor: Colors.black,
                          indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          tabs: const [
                            Tab(
                              text: 'Tuần',
                            ),
                            Tab(
                              text: 'Tháng',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: TabBarView(
                      controller: _tabController,
                      children: const [
                        ReportWeekTab(),
                        ReportMonthTab(),
                      ],
                    ),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _myWallet() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
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
                    onTap: () {},
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
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Divider(
                thickness: 1,
                color: Theme.of(context).backgroundColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.wallet,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: const Text(
                  'Wallet name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                trailing: Text(
                  _isShowBalance
                      ? '${formatter.format(balance)} ₫'
                      : '****** ₫',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _balance() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _isShowBalance
                          ? '${formatter.format(balance)}  ₫'
                          : '******  ₫',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isShowBalance = !_isShowBalance;
                          });
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
                        color: Colors.white)),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Tổng số dư ',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              Icon(
                Icons.help,
                size: 14,
                color: Colors.grey[500],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
