import 'package:equatable/equatable.dart';

import '../../../network/model/wallet.dart';

abstract class ExportState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends ExportState {}

class ErrorServerState extends ExportState {}

class ErrorInternetState extends ExportState {}

class ExportInitial extends ExportState {
  final List<Wallet> listWallet;

  ExportInitial({required this.listWallet});
}

class ExportFileState extends ExportState {}
