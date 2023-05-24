import 'package:equatable/equatable.dart';

abstract class ReportLimitEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends ReportLimitEvent {
  final int reportLimitId;

  Initial({required this.reportLimitId});
}
