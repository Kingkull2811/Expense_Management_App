import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/routes.dart';
import 'package:viet_wallet/screens/planning/balance_payments/balance_payments.dart';
import 'package:viet_wallet/screens/planning/balance_payments/current/current_bloc.dart';
import 'package:viet_wallet/screens/planning/balance_payments/precious/precious_bloc.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/day_analytic/day_analytic_bloc.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/expenditure_analysis.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/month_analytic/month_analytic_bloc.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/year_analytic/year_analytic_bloc.dart';
import 'package:viet_wallet/screens/planning/planning_bloc.dart';
import 'package:viet_wallet/screens/planning/planning_event.dart';
import 'package:viet_wallet/screens/planning/planning_state.dart';
import 'package:viet_wallet/utilities/enum/enum.dart';

import '../../utilities/enum/api_error_result.dart';
import '../../utilities/screen_utilities.dart';
import '../../widgets/animation_loading.dart';
import 'balance_payments/custom/custom_bloc.dart';
import 'balance_payments/month/month_bloc.dart';
import 'balance_payments/year/year_bloc.dart';

class PlanningPage extends StatefulWidget {
  const PlanningPage({Key? key}) : super(key: key);

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  @override
  void initState() {
    BlocProvider.of<PlanningBloc>(context).add(PlanningEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          'Báo cáo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: BlocConsumer<PlanningBloc, PlanningState>(
        listenWhen: (preState, curState) {
          return curState.apiError != ApiError.noError;
        },
        listener: (context, state) {
          if (state.apiError == ApiError.internalServerError) {
            showMessage1OptionDialog(
              context,
              'Error!',
              content: 'Internal_server_error',
            );
          }
          if (state.apiError == ApiError.noInternetConnection) {
            showMessageNoInternetDialog(context);
          }
        },
        builder: (context, state) {
          return state.isLoading
              ? const AnimationLoading()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.reportFinances,
                              );
                            },
                            child: Container(
                              width: 170,
                              height: 150,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/ic_finances.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      'Tài chính hiện tại',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<CurrentAnalyticBloc>(
                                        create: (BuildContext context) =>
                                            CurrentAnalyticBloc(context),
                                      ),
                                      BlocProvider<MonthAnalyticBlocB>(
                                        create: (BuildContext context) =>
                                            MonthAnalyticBlocB(context),
                                      ),
                                      BlocProvider<PreciousAnalyticBloc>(
                                        create: (BuildContext context) =>
                                            PreciousAnalyticBloc(context),
                                      ),
                                      BlocProvider<YearAnalyticBlocB>(
                                        create: (BuildContext context) =>
                                            YearAnalyticBlocB(context),
                                      ),
                                      BlocProvider<CustomAnalyticBloc>(
                                        create: (BuildContext context) =>
                                            CustomAnalyticBloc(context),
                                      ),
                                    ],
                                    child: BalancePayments(
                                      listWallet: state.listWallet,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 170,
                              height: 150,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/ic_balance_payment.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      'Tình hình thu chi',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<DayAnalyticBloc>(
                                        create: (BuildContext context) =>
                                            DayAnalyticBloc(context),
                                      ),
                                      BlocProvider<MonthAnalyticBloc>(
                                        create: (BuildContext context) =>
                                            MonthAnalyticBloc(context),
                                      ),
                                      BlocProvider<YearAnalyticBloc>(
                                        create: (BuildContext context) =>
                                            YearAnalyticBloc(context),
                                      ),
                                    ],
                                    child: Expenditure(
                                      listWallet: state.listWallet,
                                      listCategory: state.listExCategory,
                                      type: TransactionType.expense,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 170,
                              height: 150,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/ic_expenditure.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      'Phân tích chi tiêu',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<DayAnalyticBloc>(
                                        create: (BuildContext context) =>
                                            DayAnalyticBloc(context),
                                      ),
                                      BlocProvider<MonthAnalyticBloc>(
                                        create: (BuildContext context) =>
                                            MonthAnalyticBloc(context),
                                      ),
                                      BlocProvider<YearAnalyticBloc>(
                                        create: (BuildContext context) =>
                                            YearAnalyticBloc(context),
                                      ),
                                    ],
                                    child: Expenditure(
                                      listWallet: state.listWallet,
                                      listCategory: state.listCoCategory,
                                      type: TransactionType.income,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 170,
                              height: 150,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/ic_revenue.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      'Phân tích thu',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }
}
