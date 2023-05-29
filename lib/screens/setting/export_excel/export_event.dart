import 'package:equatable/equatable.dart';

abstract class ExportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends ExportEvent {}

class GetExport extends ExportEvent {
  final List<int> walletIDs;
  final String fromDate, toDate;

  GetExport({
    required this.walletIDs,
    required this.fromDate,
    required this.toDate,
  });
}
