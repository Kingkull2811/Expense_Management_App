import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportWeekTab extends StatefulWidget {
  const ReportWeekTab({Key? key}) : super(key: key);

  @override
  State<ReportWeekTab> createState() => _ReportWeekTabState();
}

class _ReportWeekTabState extends State<ReportWeekTab> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  ///spend less
  bool isLess = true;

  ///percent spend
  ///if less 100 - [current]/[previous]*100
  ///if more [current]/[previous]*100 - 100
  double percentSpend = 32.47;

  double balance = 155016.00;
  final formatter = NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    data = [
      _ChartData('T2', 12),
      _ChartData('T3', 15),
      _ChartData('T4', 48),
      _ChartData('T5', 15),
      _ChartData('T6', 03),
      _ChartData('T7', 15),
      _ChartData('CN', 20),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Text(
                '${formatter.format(balance)} ₫',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Tổng chi ...... ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  isLess
                      ? Icon(
                          Icons.arrow_drop_down,
                          size: 24,
                          color: Theme.of(context).primaryColor,
                        )
                      : const Icon(
                          Icons.arrow_drop_up,
                          size: 24,
                          color: Color(0xffCA0000),
                        ),
                  Text(
                    '$percentSpend %',
                    style: TextStyle(
                      fontSize: 14,
                      color: isLess
                          ? Theme.of(context).primaryColor
                          : const Color(0xffCA0000),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 250,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 50,
                  interval: 10,
                ),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<_ChartData, String>>[
                  ColumnSeries<_ChartData, String>(
                    dataSource: data,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    name: 'Week',
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 0),
              child: Text(
                'Chi tiêu nhiều nhất',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(

                decoration: BoxDecoration(
                 color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                height: 200,
                child: Center(
                  child: Text(
                    'Nhóm chi tiêu nhiều nhất\nsẽ được hiển thị ở đây.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final String x;
  final double y;

  _ChartData(this.x, this.y);
}
