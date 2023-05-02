import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/response/get_list_wallet_response.dart';

import '../../network/repository/wallet_repository.dart';
import '../../utilities/enum/api_error_result.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final BuildContext context;
  final _walletRepository = WalletRepository();

  HomePageBloc(this.context) : super(HomePageState()) {
    on((event, emit) async {
      if (event is HomeInitial) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final response = await _walletRepository.getListWallet();

          if (response is GetListWalletResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              moneyTotal: response.moneyTotal,
              listWallet: response.walletList,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listWallet: [],
            ));
          }
        }
      }
    });
  }
}
