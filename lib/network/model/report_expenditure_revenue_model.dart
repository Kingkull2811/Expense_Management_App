class ReportData {
  final String name;
  final int incomeTotal;
  final int expenseTotal;
  final int remainTotal;

  ReportData({
    required this.name,
    required this.incomeTotal,
    required this.expenseTotal,
    required this.remainTotal,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      name: json['name'] as String,
      incomeTotal: json['incomeTotal'] as int,
      expenseTotal: json['expenseTotal'] as int,
      remainTotal: json['remainTotal'] as int,
    );
  }

  @override
  String toString() {
    return 'ReportData{name: $name, incomeTotal: $incomeTotal, expenseTotal: $expenseTotal, remainTotal: $remainTotal}';
  }
}
