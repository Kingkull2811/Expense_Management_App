import 'package:equatable/equatable.dart';

abstract class DayAnalyticEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DayAnalyticInit extends DayAnalyticEvent {
  final String fromDate, toDate;
  final List<int> categoryIDs, walletIDs;

  DayAnalyticInit({
    required this.fromDate,
    required this.toDate,
    required this.categoryIDs,
    required this.walletIDs,
  });
}
