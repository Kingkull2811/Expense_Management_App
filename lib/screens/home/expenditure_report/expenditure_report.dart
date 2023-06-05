import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:viet_wallet/screens/home/expenditure_report/expenditure_report_bloc.dart';
import 'package:viet_wallet/screens/home/expenditure_report/expenditure_report_state.dart';

import '../../../network/model/category_report_model.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/animation_loading.dart';
import 'expenditure_report_event.dart';

class ExpenditureReport extends StatefulWidget {
  const ExpenditureReport({Key? key}) : super(key: key);

  @override
  State<ExpenditureReport> createState() => _ExpenditureReportState();
}

class _ExpenditureReportState extends State<ExpenditureReport> {
  late TooltipBehavior _tooltip;

  bool _showDetail = false;

  @override
  void initState() {
    BlocProvider.of<ExpenditureReportBloc>(context)
        .add(ExpenditureReportEvent());
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenditureReportBloc, ExpenditureReportState>(
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
                      const Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10.0),
                        child: Text(
                          '(Đơn vị: %)',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 350,
                        child: SfCircularChart(
                          tooltipBehavior: _tooltip,
                          series: <CircularSeries>[
                            PieSeries<CategoryReportModel, String>(
                              dataSource: listReport,
                              xValueMapper: (CategoryReportModel data, _) =>
                                  data.categoryName,
                              yValueMapper: (CategoryReportModel data, _) =>
                                  data.percent,
                              name: 'Chi',
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
