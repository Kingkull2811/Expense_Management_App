import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:viet_wallet/routes.dart';
import 'package:viet_wallet/services/notification_service.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // _removeBadgeWhenOpenApp();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Init SharedPreferences storage
  await SharedPreferencesStorage.init();

  runApp(MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
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
  bool _isLoggedIn = false;

  @override
  void initState() {
    _checkAuthenticationState();
    NotificationServices().requestNotificationPermission();
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
      primaryColor: const Color.fromARGB(255, 107, 154, 107), //#6B9A6B
      primaryColorDark: const Color(0xff4d6e4b),
      primaryColorLight: const Color(0xFFb5ccb5),
      colorScheme: ThemeData().colorScheme.copyWith(
            primary: Colors.grey,
            secondary: const Color(0xffe6e6e6),
          ),
      errorColor: const Color(0xFFCA0000),
      backgroundColor: Colors.grey[200],
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
      localizationsDelegates: const [
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // DefaultCupertinoLocalizations.delegate
      ],
      title: 'Viet Wallet App',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.white),
      ),
      routes: AppRoutes().routes(context, isLoggedIn: _isLoggedIn),
    );
  }

  _checkAuthenticationState() {
    bool isLoggedOut = SharedPreferencesStorage().getLoggedOutStatus();
    bool isExpired = true;
    String passwordExpiredTime =
        SharedPreferencesStorage().getAccessTokenExpired();
    if (passwordExpiredTime.isNotEmpty) {
      try {
        if (DateTime.parse(passwordExpiredTime).isAfter(DateTime.now())) {
          isExpired = false;
        }
      } catch (_) {}

      if (!isExpired) {
        if (isLoggedOut) {
          setState(() {
            _isLoggedIn = false;
          });
        } else {
          setState(() {
            _isLoggedIn = true;
          });
        }
      } else {
        setState(() {
          _isLoggedIn = false;
        });
      }
    }
  }
}
