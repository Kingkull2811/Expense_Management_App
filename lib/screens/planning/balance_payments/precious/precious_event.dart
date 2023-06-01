import 'package:equatable/equatable.dart';

class PreciousAnalyticEvent extends Equatable {
  final List<int> walletIDs;

  const PreciousAnalyticEvent({
    required this.walletIDs,
  });

  @override
  List<Object?> get props => [];
}
