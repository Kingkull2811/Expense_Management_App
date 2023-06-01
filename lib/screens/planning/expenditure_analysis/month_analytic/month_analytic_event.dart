import 'package:equatable/equatable.dart';

import '../../../../utilities/enum/enum.dart';

class MonthAnalyticEvent extends Equatable {
  final String fromMonth, toMonth;
  final List<int> walletIDs, categoryIDs;
  final TransactionType type;

  const MonthAnalyticEvent(
      {required this.fromMonth,
      required this.toMonth,
      required this.walletIDs,
      required this.categoryIDs,
      this.type = TransactionType.expense});

  @override
  List<Object?> get props => [];
}
