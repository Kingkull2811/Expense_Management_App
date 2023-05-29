import 'package:equatable/equatable.dart';

class DayAnalyticEvent extends Equatable {
  final String fromDate, toDate;
  final List<int> walletIDs, categoryIDs;

  const DayAnalyticEvent({
    required this.fromDate,
    required this.toDate,
    required this.walletIDs,
    required this.categoryIDs,
  });

  @override
  List<Object?> get props => [];
}
