import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'balance_payments/payments.position.bloc.dart';
import 'balance_payments/payments.position.page.dart';
import 'expenditure_analysis/expenditure_analysis.dart';
import 'expenditure_analysis/expenditure_analysis_bloc.dart';

class PlanningPage extends StatefulWidget {
  const PlanningPage({Key? key}) : super(key: key);

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          title: const Text('Báo cáo'),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 170,
                  height: 150,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10))),
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BlocProvider<PaymentsPositionBloc>(
                          create: (context) => PaymentsPositionBloc(context),
                          child: const PaymentPosition(),
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
                            right: Radius.circular(10))),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider<ExpenditureBloc>(
                          create: (context) => ExpenditureBloc(context),
                          child: const Expenditure(),
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
      ),
    );
  }
}
