import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/routes.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/expenditure_analysis.dart';
import 'package:viet_wallet/screens/planning/planning_bloc.dart';
import 'package:viet_wallet/screens/planning/planning_event.dart';
import 'package:viet_wallet/screens/planning/planning_state.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';

import '../../utilities/enum/api_error_result.dart';
import '../../utilities/screen_utilities.dart';

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
                              Navigator.pushNamed(context, AppRoutes.myWallet);
                            },
                            child: Container(
                              width: 170,
                              height: 150,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(width: 4),
                                  Text(
                                    'Tài chính hiện tại',
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.pushNamed(context, AppRoutes.reportPayment);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Expenditure(
                                    listWallet: state.listWallet,
                                    listCategory: state.listExCategory ?? [],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 170,
                              height: 150,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(width: 4),
                                  Text(
                                    'Tình hình thu chi',
                                  )
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
                              // Navigator.pushNamed(context, AppRoutes.reportExpenditure);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Expenditure(
                                    listWallet: state.listWallet,
                                    listCategory: state.listExCategory,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 170,
                              height: 150,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(width: 4),
                                  Text(
                                    'Phân tích chi tiêu',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 170,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(width: 4),
                                Text(
                                  'Phân tích thu',
                                )
                              ],
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
