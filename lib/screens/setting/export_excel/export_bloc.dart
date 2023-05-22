import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/provider/export_file_provider.dart';
import 'package:viet_wallet/network/provider/wallet_provider.dart';
import 'package:viet_wallet/network/response/base_get_response.dart';

import '../../../network/response/get_list_wallet_response.dart';
import '../../../utilities/screen_utilities.dart';
import 'export_event.dart';
import 'export_state.dart';

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  final BuildContext context;

  final _exportProvider = ExportProvider();
  final _walletProvider = WalletProvider();

  ExportBloc(this.context) : super(LoadingState()) {
    on<ExportEvent>((event, emit) async {
      if (event is Initial) {
        emit(LoadingState());

        final response = await _walletProvider.getListWallet();
        if (response is GetListWalletResponse) {
          emit(ExportInitial(
            listWallet: response.walletList ?? [],
          ));
        } else if (response is ExpiredTokenGetResponse) {
          logoutIfNeed(this.context);
        } else {
          emit(ErrorServerState());
        }
      }
      if (event is GetExport) {
        final Map<String, dynamic> query = {
          'fromDate': event.formDate,
          'toDate': event.toDate
        };

        print('listInt: ${event.walletIDs.toString()}');

        final response = await _exportProvider.getFileReport(
          query,
          event.walletIDs,
        );
        log(response.toString());
      }
    });
  }
}