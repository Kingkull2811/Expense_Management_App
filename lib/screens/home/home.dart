import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/routes.dart';
import 'package:viet_wallet/screens/home/home_bloc.dart';
import 'package:viet_wallet/screens/home/home_event.dart';
import 'package:viet_wallet/screens/home/home_state.dart';
import 'package:viet_wallet/screens/home/report_month/report_month.dart';
import 'package:viet_wallet/screens/home/report_week/report_week.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';

import '../../network/model/wallet.dart';
import '../../utilities/screen_utilities.dart';
import '../../utilities/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _isShowBalance = SharedPreferencesStorage().getHiddenAmount() ?? false;
  int notificationBadge = 3;

  late HomePageBloc _homePageBloc;

  late TabController _tabController;

  final String currency = SharedPreferencesStorage().getCurrency() ?? '';

  @override
  void initState() {
    _homePageBloc = BlocProvider.of<HomePageBloc>(context);
    _homePageBloc.add(HomeInitial());
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
        Widget body = const SizedBox.shrink();
        if (curState.isLoading) {
          body = const Scaffold(body: AnimationLoading());
        } else {
          body = _body(context, curState);
        }
        return body;
      },
    );
  }

  Widget _body(BuildContext context, HomePageState state) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _balance((state.moneyTotal ?? 0).toDouble()),
              _myWallet(state.listWallet),
              _expenseReport(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _expenseReport() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
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
                            padding: const EdgeInsets.all(2),
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
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: const [
                            ReportWeekTab(),
                            ReportMonthTab(),
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
    return SizedBox(
      height: 60 * ((listWallet?.length ?? 0) + 1).toDouble() + 15,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: (listWallet?.length ?? 0) + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                height: 47,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
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
                                Navigator.pushNamed(
                                    context, AppRoutes.myWallet);
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
                  ],
                ),
              );
            }
            return _createItemWallet(
              context,
              listWallet?[index - 1],
              thisIndex: index - 1,
              endIndex: (listWallet?.length ?? 0) - 1,
            );
          }),
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
                          maxWidth: MediaQuery.of(context).size.width * 0.8),
                      child: Text(
                        _isShowBalance
                            ? '${formatterDouble(balance)}  $currency'
                            : '******  $currency',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
        ],
      ),
    );
  }

  Widget _createItemWallet(
    BuildContext context,
    Wallet? wallet, {
    required int thisIndex,
    required int endIndex,
  }) {
    return Container(
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
                isNotNullOrEmpty(wallet?.accountType)
                    ? getIconWallet(walletType: wallet?.accountType ?? '')
                    : Icons.help_outline,
                size: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${wallet?.name}',
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
                  ? '${formatterDouble((wallet?.accountBalance ?? 0).toDouble())} $currency'
                  : '****** $currency',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
