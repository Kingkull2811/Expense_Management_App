import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/provider/category_provider.dart';
import '../../../network/provider/wallet_provider.dart';
import '../../../network/response/base_get_response.dart';
import '../../../network/response/get_list_category_response.dart';
import '../../../network/response/get_list_wallet_response.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import 'expenditure_analytic_event.dart';
import 'expenditure_analytic_state.dart';

class ExpenditureAnalyticBloc
    extends Bloc<ExpenditureAnalyticEvent, ExpenditureAnalyticState> {
  final BuildContext context;
  final _categoryProvider = CategoryProvider();
  final _walletProvider = WalletProvider();

  ExpenditureAnalyticBloc(this.context) : super(ExpenditureAnalyticState()) {
    on((event, emit) async {
      if (event is ExpenditureAnalyticEvent) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(
            state.copyWith(
              isLoading: false,
              apiError: ApiError.noInternetConnection,
            ),
          );
        } else {
          final responseExpense =
              await _categoryProvider.getAllListCategory(param: "EXPENSE");
          if (responseExpense is GetCategoryResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listExCategory: responseExpense.listCategory,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listExCategory: [],
            ));
          }

          final walletResponse = await _walletProvider.getListWallet();
          if (walletResponse is GetListWalletResponse) {
            emit(
              state.copyWith(
                isLoading: false,
                apiError: ApiError.noError,
                listWallet: walletResponse.walletList,
              ),
            );
          } else if (walletResponse is ExpiredTokenGetResponse) {
            logoutIfNeed(this.context);
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
