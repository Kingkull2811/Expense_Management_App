import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:viet_wallet/screens/home/revenue_report/revenue_report_bloc.dart';
import 'package:viet_wallet/screens/home/revenue_report/revenue_report_event.dart';
import 'package:viet_wallet/screens/home/revenue_report/revenue_report_state.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';

import '../../../network/model/category_report_model.dart';
import '../../../utilities/utils.dart';

class RevenueReport extends StatefulWidget {
  const RevenueReport({Key? key}) : super(key: key);

  @override
  State<RevenueReport> createState() => _RevenueReportState();
}

class _RevenueReportState extends State<RevenueReport> {
  late TooltipBehavior _tooltip;

  bool _showDetail = true;

  @override
  void initState() {
    BlocProvider.of<RevenueReportBloc>(context).add(RevenueReportEvent());
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RevenueReportBloc, RevenueReportState>(
      builder: (context, state) {
        List<CategoryReportModel> listReport = state.listReport ?? [];
        listReport.sort((a, b) => b.percent.compareTo(a.percent));
        return state.isLoading
            ? const AnimationLoading()
            : SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 400,
                        child: SfCircularChart(
                          tooltipBehavior: _tooltip,
                          series: <CircularSeries>[
                            PieSeries<CategoryReportModel, String>(
                              dataSource: listReport,
                              xValueMapper: (CategoryReportModel data, _) =>
                                  data.categoryName,
                              yValueMapper: (CategoryReportModel data, _) =>
                                  data.percent,
                              name: 'Thu',
                            ),
                          ],
                        ),
                      ),
                      listDetails(listReport),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget listDetails(List<CategoryReportModel>? listReport) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget details(CategoryReportModel report) {
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
              report.categoryName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Text(
              '${formatterDouble(report.percent)} %',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
