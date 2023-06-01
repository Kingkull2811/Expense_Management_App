import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_bloc.dart';
import 'package:viet_wallet/screens/main_app/main_app.dart';
import 'package:viet_wallet/screens/my_wallet/add_new_wallet/add_new_wallet.dart';
import 'package:viet_wallet/screens/planning/current_finances/current_finances.dart';
import 'package:viet_wallet/screens/planning/current_finances/current_finances_bloc.dart';
import 'package:viet_wallet/screens/planning/current_finances/current_finances_event.dart';
import 'package:viet_wallet/screens/setting/category/category_item/category_item.dart';
import 'package:viet_wallet/screens/setting/category/category_item/category_item_bloc.dart';
import 'package:viet_wallet/screens/setting/export_excel/export.dart';
import 'package:viet_wallet/screens/setting/export_excel/export_bloc.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/limit.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/limit_bloc.dart';
import 'package:viet_wallet/screens/setting/recurring_transaction/recurring_transaction.dart';
import 'package:viet_wallet/screens/setting/recurring_transaction/recurring_transaction_bloc.dart';
import 'package:viet_wallet/screens/setting/security/security.dart';

import 'screens/planning/balance_payments/balance_payments.dart';
import 'screens/planning/expenditure_analysis/expenditure_analysis.dart';

class AppRoutes {
  static const mainApp = '/';

  static const home = '/home';

  static const myWallet = '/myWallet';
  static const addWallet = '/myWallet/add';
  static const walletDetails = '/myWallet/walletDetails';

  static const report = '/report';
  static const reportPayment = '/report/payment';
  static const reportFinances = '/report/finances';
  static const reportExpenditure = '/report/expenditure';
  static const newCollection = '/new';

  static const login = '/login';

  static const settings = '/settings';
  static const security = '/settings/security';
  static const category = '/settings/category';
  static const limit = '/settings/limit';
  static const recurring = '/settings/recurring';
  static const exportFile = '/settings/export';

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
      AppRoutes.settings: (context) {
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
      AppRoutes.security: (context) {
        return const SecurityPage();
      },
      AppRoutes.reportPayment: (context) {
        return const BalancePayments();
      },
      AppRoutes.reportFinances: (context) {
        return BlocProvider<CurrentFinancesBloc>(
          create: (context) =>
              CurrentFinancesBloc(context)..add(CurrentFinancesInitEvent()),
          child: const CurrentFinances(),
        );
      },
      AppRoutes.reportExpenditure: (context) {
        return const Expenditure();
      },
      AppRoutes.category: (context) {
        return BlocProvider<CategoryItemBloc>(
          create: (context) => CategoryItemBloc(context),
          child: const CategoryItem(),
        );
      },
      AppRoutes.limit: (context) {
        return BlocProvider<LimitBloc>(
          create: (context) => LimitBloc(context),
          child: const LimitPage(),
        );
      },
      AppRoutes.recurring: (context) {
        return BlocProvider<RecurringTransactionBloc>(
          create: (context) => RecurringTransactionBloc(context),
          child: const RecurringPage(),
        );
      },
      AppRoutes.exportFile: (context) {
        return BlocProvider<ExportBloc>(
          create: (context) => ExportBloc(context),
          child: const ExportPage(),
        );
      },
    };
  }
}
