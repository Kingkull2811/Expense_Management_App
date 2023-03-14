import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/routes.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in.dart';
import 'package:viet_wallet/utilities/helper_functions.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _removeBadgeWhenOpenApp();

  //init global key for tabs
  // DatabaseService().homeKey = GlobalKey<HomePageState>();
  // DatabaseService().myWalletKey = GlobalKey<MyWalletPageState>();
  // DatabaseService().newCollectionKey = GlobalKey<NewCollectionPageState>();
  // DatabaseService().reportKey = GlobalKey<ReportPageState>();
  // DatabaseService().otherKey = GlobalKey<OtherPageState>();

  // Init SharedPreferences storage
  await SharedPreferencesStorage.init();

  runApp(MyApp());
}

_removeBadgeWhenOpenApp() async {
  bool osSupportBadge = await FlutterAppBadger.isAppBadgeSupported();
  if (osSupportBadge && Platform.isIOS) {
    FlutterAppBadger.removeBadge();
  }
}

class MyApp extends StatefulWidget {
  final navKey = GlobalKey<NavigatorState>();

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  bool _isLogin = false;

  @override
  void initState() {
    _getUserSignInStatus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color.fromARGB(255, 107, 154, 107),
      errorColor: const Color(0xFFCA0000),
      backgroundColor: Colors.white,
      textTheme: Theme.of(context).textTheme.apply(
        bodyColor: const Color.fromARGB(255, 26, 26, 26),
        displayColor: const Color.fromARGB(255, 26, 26, 26),
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: widget.navKey,
        supportedLocales: const [
          Locale('en'),
          Locale('vi'),
        ],
        // localizationsDelegates: [
        //   AppLocalizations.delegate,
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        //   DefaultCupertinoLocalizations.delegate
        // ],
        title: 'Viet Wallet App',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.white),
      ),
      routes: {
        AppRoutes.mainApp: (context) => BlocProvider<SignInBloc>(
          create: (context) => SignInBloc(context),
          child: SignInScreen(),
        ),
      },

    );
  }

  _getUserSignInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isLogin = value;
        });
      }
    });
  }
}