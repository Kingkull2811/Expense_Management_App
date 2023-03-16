import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportMonthTab extends StatefulWidget {
  const ReportMonthTab({Key? key}) : super(key: key);

  @override
  State<ReportMonthTab> createState() => _ReportMonthTabState();
}

class _ReportMonthTabState extends State<ReportMonthTab> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  ///spend less
  bool isLess = false;

  ///percent spend
  ///if less 100 - [current]/[previous]*100
  ///if more [current]/[previous]*100 - 100
  double percentSpend = 70.47;

  double balance = 155016.00;
  final formatter = NumberFormat("#,##0.00", "en_US");


  @override
  void initState() {
    data = [
      _ChartData('Tháng 1', 12),
      _ChartData('Tháng 2', 15),
      _ChartData('Tháng 3', 30),
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
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 40,
                  interval: 10,
                ),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<_ChartData, String>>[
                  ColumnSeries<_ChartData, String>(
                    dataSource: data,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    name: 'Month',
                    color: const Color.fromARGB(255, 90, 200, 150),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)
                    ),
                  )
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
