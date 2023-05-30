import 'package:equatable/equatable.dart';

class MonthAnalyticEvent extends Equatable {
  final String fromMonth, toMonth;
  final List<int> walletIDs, categoryIDs;

  const MonthAnalyticEvent({
    required this.fromMonth,
    required this.toMonth,
    required this.walletIDs,
    required this.categoryIDs,
  });

  @override
  List<Object?> get props => [];
}
