import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_bloc.dart';
import 'package:viet_wallet/screens/main_app/main_app.dart';
import 'package:viet_wallet/screens/my_wallet/add_new_wallet/add_new_wallet.dart';

class AppRoutes {
  static const mainApp = '/';

  static const home = '/home';

  static const myWallet = '/myWallet';
  static const addWallet = '/myWallet/add';
  static const walletDetails = '/myWallet/walletDetails';

  static const report = '/report';
  static const newCollection = '/new';
  static const profile = '/profile';

  static const login = '/login';

  Map<String, Widget Function(BuildContext)> routes(BuildContext context,
      {required bool isLoggedIn}) {
    return {
      AppRoutes.mainApp: (context) => isLoggedIn
          ? MainApp(currentTab: 0)
          : BlocProvider<SignInBloc>(
              create: (context) => SignInBloc(context),
              child: const SignInPage(),
            ),
      AppRoutes.home: (context) {
        return MainApp(currentTab: 0);
      },
      AppRoutes.myWallet: (context) {
        return MainApp(currentTab: 1);
      },
      AppRoutes.newCollection: (context) {
        return MainApp(currentTab: 2);
      },
      AppRoutes.report: (context) {
        return MainApp(currentTab: 3);
      },
      AppRoutes.profile: (context) {
        return MainApp(currentTab: 4);
      },
      AppRoutes.login: (context) {
        return BlocProvider<SignInBloc>(
          create: (context) => SignInBloc(context),
          child: const SignInPage(),
        );
      },
      AppRoutes.addWallet: (context) {
        return const AddNewWalletPage();
      },
    };
  }
}
