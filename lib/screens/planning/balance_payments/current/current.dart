import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/day_analytic/day_analytic_state.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';

import '../../../../network/model/analytic_model.dart';
import '../../../../utilities/shared_preferences_storage.dart';
import 'current_bloc.dart';
import 'current_event.dart';

class CurrentAnalytic extends StatefulWidget {
  final List<int> walletIDs;
  const CurrentAnalytic({
    Key? key,
    required this.walletIDs,
  }) : super(key: key);

  @override
  State<CurrentAnalytic> createState() => _CurrentAnalyticState();
}

class _CurrentAnalyticState extends State<CurrentAnalytic> {
  final currency = SharedPreferencesStorage().getCurrency() ?? '\$/USD';
  bool _showDetail = false;

  @override
  void initState() {
    BlocProvider.of<CurrentAnalyticBloc>(context).add(CurrentAnalyticEvent(
      walletIDs: widget.walletIDs,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentAnalyticBloc, CurrentAnalyticState>(
      builder: (context, state) {
        List<CategoryReport> listReport = state.data?.categoryReports ?? [];

        return state.isLoading
            ? const AnimationLoading()
            : Padding(
                padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '(Đơn vị: nghìn VNĐ)',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                    SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries>[
                        LineSeries<CategoryReport, String>(
                          dataSource: listReport,
                          xValueMapper: (CategoryReport data, _) =>
                              DateFormat('dd/MM')
                                  .format(DateTime.parse(data.time)),
                          yValueMapper: (CategoryReport data, _) =>
                              data.totalAmount / 1000,
                          name: 'CategoryReport',
                          color: Colors.lightBlueAccent,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng chi tiêu',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            '${state.data?.totalAmount} $currency',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Trung bình chỉ/ngày',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${state.data?.mediumAmount} $currency',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.2),
                      height: 10,
                      thickness: 10,
                    ),
                    listFilter(listReport),
                  ],
                ),
              );
      },
    );
  }

  Widget listFilter(List<CategoryReport>? listReport) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _showDetail = !_showDetail;
              });
            },
            child: SizedBox(
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    _showDetail
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (_showDetail)
            SizedBox(
              height: 40 * (listReport!.length).toDouble(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listReport.length,
                itemBuilder: (context, index) => details(listReport[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget details(CategoryReport report) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.2)),
            bottom: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.2)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              report.time,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Row(
              children: [
                Text(
                  '${report.totalAmount} $currency ',
                  style: const TextStyle(color: Colors.red),
                ),
                const Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: 20,
                  color: Colors.grey,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
