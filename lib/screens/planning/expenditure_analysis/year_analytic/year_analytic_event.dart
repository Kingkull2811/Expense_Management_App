import 'package:equatable/equatable.dart';

class YearAnalyticEvent extends Equatable {
  final String fromYear, toYear;
  final List<int> walletIDs, categoryIDs;

  const YearAnalyticEvent({
    required this.fromYear,
    required this.toYear,
    required this.walletIDs,
    required this.categoryIDs,
  });

  @override
  List<Object?> get props => [];
}
