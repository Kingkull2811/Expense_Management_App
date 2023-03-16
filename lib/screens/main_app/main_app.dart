import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:viet_wallet/screens/account/account.dart';
import 'package:viet_wallet/screens/account/account_bloc.dart';
import 'package:viet_wallet/screens/home/home_bloc.dart';
import 'package:viet_wallet/screens/home/home.dart';
import 'package:viet_wallet/screens/main_app/tab/tab_bloc.dart';
import 'package:viet_wallet/screens/main_app/tab/tab_event.dart';
import 'package:viet_wallet/screens/main_app/tab/tab_selector.dart';
import 'package:viet_wallet/screens/new_collection/new_collection.dart';
import 'package:viet_wallet/screens/new_collection/new_collection_bloc.dart';
import 'package:viet_wallet/screens/planning/planning.dart';
import 'package:viet_wallet/screens/planning/planning_bloc.dart';

import '../../utilities/database.dart';
import '../my_wallet/my_wallet.dart';
import '../my_wallet/my_wallet_bloc.dart';

class MainApp extends StatefulWidget {
  final bool navFromStart;

  MainApp({key, this.navFromStart = false})
      : super(key: GlobalKey<MainAppState>());

  @override
  MainAppState createState() {
    // DatabaseService().chatKey = this.key as GlobalKey<State<StatefulWidget>>?;
    return MainAppState();
  }
}

class MainAppState extends State<MainApp>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  StreamSubscription<ConnectivityResult>? _networkSubscription;


  @override
  void initState() {
    _tabController = TabController(length: AppTab.values.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    if (_networkSubscription != null) {
      _networkSubscription?.cancel();
    }
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: Future.wait([getChatBadge()]),
        builder: (context, snapshot) {
          return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
            _tabController?.index = AppTab.values.indexOf(activeTab);
            return Scaffold(
              body: _handleScreen(activeTab),
              bottomNavigationBar: TabSelector(
                  activeTab: activeTab,
                  onTabSelected: (tab) async {
                    BlocProvider.of<TabBloc>(context).add(TabUpdated(tab));
                    setState(() {});
                  }),
            );
          });
        });
  }

  _handleScreen(AppTab activeTab) {
    Widget currentTab;
    switch (activeTab) {
      case AppTab.home:
        currentTab = BlocProvider(
          create: (context) => HomePageBloc(context),
          child: HomePage(
            key: DatabaseService().homeKey,
          ),
        );
        break;
      case AppTab.myWallet:
        currentTab = BlocProvider<MyWalletPageBloc>(
          create: (context) => MyWalletPageBloc(context),
          child: MyWalletPage(
            key: DatabaseService().myWalletKey,
          ),
        );
        break;
      case AppTab.newCollection:
        currentTab = BlocProvider<NewCollectionBloc>(
          create: (context) => NewCollectionBloc(context),
          child: NewCollectionPage(
            key: DatabaseService().newCollectionKey,
          ),
        );
        break;
      case AppTab.report:
        currentTab = BlocProvider<PlanningBloc>(
          create: (context) => PlanningBloc(context),
          child: PlanningPage(
            key: DatabaseService().planningKey,
          ),
        );
        break;
      case AppTab.other:
        currentTab = BlocProvider<AccountBloc>(
          create: (context) => AccountBloc(context),
          child: AccountPage(
            key: DatabaseService().accountKey,
          ),
        );
        break;
      default:
        currentTab = BlocProvider(
          create: (context) => HomePageBloc(context),
          child: HomePage(
            key: DatabaseService().homeKey,
          ),
        );
    }
    return currentTab;
  }

  Future<int?> getChatBadge() async {
    int chatNumber = 2;
    return chatNumber;
  }

  // Update badge for bottom tab
  void reloadPage() {
    setState(() {});
  }


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Are you sure exit app?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Do you want to exit an App',
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Exits',
              style: TextStyle(color: Color(0xffCA0000)),
            ),
          ),
        ],
      ),
    )) ??
        false;
  }
}
