import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:viet_wallet/screens/home/home_bloc.dart';
import 'package:viet_wallet/screens/home/home.dart';
import 'package:viet_wallet/screens/main_app/tab/tab_bloc.dart';
import 'package:viet_wallet/screens/main_app/tab/tab_event.dart';
import 'package:viet_wallet/screens/main_app/tab/tab_selector.dart';

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
  int newChatBadge = 0;
  int newsBadge = 0;
  int newTranscriptBadge = 0;

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
                  newChatsBadgeNumber: 1,
                  newsBadgeNumber: 2,
                  newTranscriptBadgeNumber: 1,
                  onTabSelected: (tab) async {
                    // if (activeTab == AppTab.chat && tab != AppTab.chat) {
                    //   //todo:
                    //   if (kDebugMode) {
                    //     print('tab # chat');
                    //   }
                    // }
                    // if (tab == AppTab.chat) {
                    //   if (kDebugMode) {
                    //     print('tab chat');
                    //   }
                    // }
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
      // case AppTab.newCollection:
      //   // currentTab = BlocProvider<NewCollectionPageBloc>(
      //   //   create: (context) => NewCollectionPageBloc(context),
      //   //   child: NewCollectionPage(
      //   //     key: DatabaseService().newCollectionKey,
      //   //   ),
      //   // );
      //   break;
      // case AppTab.report:
      //   // currentTab = BlocProvider<ReportPageBloc>(
      //   //   create: (context) => ReportPageBloc(context),
      //   //   child: ReportPage(
      //   //     key: DatabaseService().reportKey,
      //   //   ),
      //   // );
      //   break;
      // case AppTab.other:
      //   // currentTab = BlocProvider<OtherPageBloc>(
      //   //   create: (context) => OtherPageBloc(context),
      //   //   child: OtherPage(
      //   //     key: DatabaseService().otherKey,
      //   //   ),
      //   // );
      //   break;
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

  // void changeTabToChat() {
  //   BlocProvider.of<TabBloc>(context).add(TabUpdated(AppTab.chat));
  // }
  //
  // void changeTabToNews() {
  //   BlocProvider.of<TabBloc>(context).add(TabUpdated(AppTab.news));
  // }
  //
  // void changeTabToTranscript() {
  //   BlocProvider.of<TabBloc>(context).add(TabUpdated(AppTab.transcript));
  // }
  //
  // void changeTabToProfile() {
  //   BlocProvider.of<TabBloc>(context).add(TabUpdated(AppTab.profile));
  // }

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