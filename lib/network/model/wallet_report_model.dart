import 'day_transcaction_model.dart';

class WalletReport {
  final int? expenseTotal;
  final int? incomeTotal;
  final int? currentBalance;
  final List<DayTransaction>? dayTransactionList;

  WalletReport({
    this.expenseTotal,
    this.incomeTotal,
    this.currentBalance,
    this.dayTransactionList,
  });
  factory WalletReport.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dayTransactionListJson = json['dayTransactionList'];
    final List<DayTransaction> dayTransactionList = dayTransactionListJson
        .map(
            (dayTransactionJson) => DayTransaction.fromJson(dayTransactionJson))
        .toList();

    return WalletReport(
      expenseTotal: json['expenseTotal'] as int?,
      incomeTotal: json['incomeTotal'] as int?,
      currentBalance: json['currentBalance'] as int?,
      dayTransactionList: dayTransactionList,
    );
  }

  @override
  String toString() {
    return 'WalletReport{expenseTotal: $expenseTotal, incomeTotal: $incomeTotal, currentBalance: $currentBalance, dayTransactionList: $dayTransactionList}';
  }
}
