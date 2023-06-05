import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/repository/wallet_repository.dart';
import 'package:viet_wallet/network/response/base_get_response.dart';
import 'package:viet_wallet/network/response/get_list_wallet_response.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';
import 'package:viet_wallet/utilities/screen_utilities.dart';

import 'current_finances_event.dart';
import 'current_finances_state.dart';

class CurrentFinancesBloc
    extends Bloc<CurrentFinancesEvent, CurrentFinancesState> {
  final _walletRepository = WalletRepository();
  final BuildContext context;

  CurrentFinancesBloc(this.context) : super(CurrentFinancesState()) {
    on((event, emit) async {
      if (event is CurrentFinancesInitEvent) {
        emit(state.copyWith(isLoading: true));
        ConnectivityResult networkStatus =
            await Connectivity().checkConnectivity();
        if (networkStatus == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
          return;
        }
        final response = await _walletRepository.getListWallet();
        if (response is GetListWalletResponse) {
          emit(state.copyWith(
            isLoading: false,
            listWallet: response.walletList,
            apiError: ApiError.noError,
          ));
        } else if (response is ExpiredTokenGetResponse) {
          logoutIfNeed(this.context);
        } else {
          emit(state.copyWith(
            isLoading: false,
            listWallet: [],
            apiError: ApiError.internalServerError,
          ));
        }
      }
    });
  }
}
