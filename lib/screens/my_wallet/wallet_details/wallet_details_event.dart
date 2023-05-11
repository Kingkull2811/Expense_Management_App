import 'package:equatable/equatable.dart';

abstract class WalletDetailsEvent extends Equatable {
  const WalletDetailsEvent();
  @override
  List<Object?> get props => [];
}

class WalletDetailInit extends WalletDetailsEvent {
  final int? walletId;
  final String? fromDate;
  final String? toDate;

  const WalletDetailInit({
    this.walletId,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [walletId];
}
