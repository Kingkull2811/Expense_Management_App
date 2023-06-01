import 'package:equatable/equatable.dart';

import '../../../../utilities/enum/enum.dart';

class YearAnalyticEvent extends Equatable {
  final String fromYear, toYear;
  final List<int> walletIDs, categoryIDs;
  final TransactionType type;
  const YearAnalyticEvent(
      {required this.fromYear,
      required this.toYear,
      required this.walletIDs,
      required this.categoryIDs,
      this.type = TransactionType.expense});

  @override
  List<Object?> get props => [];
}
