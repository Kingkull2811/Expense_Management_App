import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/home/home.dart';
import 'package:viet_wallet/screens/home/home_bloc.dart';
import 'package:viet_wallet/screens/new_collection/new_collection.dart';
import 'package:viet_wallet/screens/new_collection/new_collection_bloc.dart';
import 'package:viet_wallet/screens/planning/planning.dart';
import 'package:viet_wallet/screens/planning/planning_bloc.dart';

import '../../utilities/database.dart';
import '../my_wallet/my_wallet.dart';
import '../my_wallet/my_wallet_bloc.dart';
import '../setting/setting.dart';
import '../setting/setting_bloc.dart';

class MainApp extends StatefulWidget {
  final int? currentTab;

  MainApp({key, this.currentTab}) : super(key: GlobalKey<MainAppState>());

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> with WidgetsBindingObserver {
  StreamSubscription<ConnectivityResult>? _networkSubscription;

  @override
  void initState() {
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
        return WillPopScope(
          onWillPop: _onWillPop,
          child: CupertinoTabScaffold(
            tabBar: _tabBar(),
            tabBuilder: (context, index) => _handleScreen(context, index),
          ),
        );
      },
    );
  }

  CupertinoTabBar _tabBar() {
    return CupertinoTabBar(
      currentIndex: widget.currentTab ?? 0,
      activeColor: Colors.grey[600],
      inactiveColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.grey[50],
      iconSize: 30,
      height: 50,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          activeIcon: Icon(
            Icons.home_outlined,
            size: 30,
            color: Colors.grey[600],
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_balance_wallet,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          activeIcon: Icon(
            Icons.account_balance_wallet_outlined,
            size: 30,
            color: Colors.grey[600],
          ),
          label: 'My Wallet',
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).primaryColor,
            ),
            child: const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
          activeIcon: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey[600],
            ),
            child: const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
          label: "New Collection",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bar_chart,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          activeIcon: Icon(
            Icons.bar_chart_outlined,
            size: 30,
            color: Colors.grey[600],
          ),
          label: 'Planning',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.grid_view,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          activeIcon: Icon(
            Icons.grid_view,
            size: 30,
            color: Colors.grey[600],
          ),
          label: 'Menu',
        ),
      ],
    );
  }

  _handleScreen(BuildContext context, int index) {
    Widget currentTab;
    switch (index) {
      case 0:
        currentTab = BlocProvider(
          create: (context) => HomePageBloc(context),
          child: HomePage(
            key: DatabaseService().homeKey,
          ),
        );
        break;
      case 1:
        currentTab = BlocProvider<MyWalletPageBloc>(
          create: (context) => MyWalletPageBloc(context),
          child: MyWalletPage(
            key: DatabaseService().myWalletKey,
          ),
        );
        break;
      case 2:
        currentTab = BlocProvider<NewCollectionBloc>(
          create: (context) => NewCollectionBloc(context),
          child: NewCollectionPage(
            key: DatabaseService().newCollectionKey,
          ),
        );
        break;
      case 3:
        currentTab = BlocProvider<PlanningBloc>(
          create: (context) => PlanningBloc(context),
          child: PlanningPage(
            key: DatabaseService().planningKey,
          ),
        );
        break;
      case 4:
        currentTab = BlocProvider<SettingBloc>(
          create: (context) => SettingBloc(context),
          child: SettingPage(
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
