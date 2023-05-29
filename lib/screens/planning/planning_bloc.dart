import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/provider/category_provider.dart';
import 'package:viet_wallet/network/provider/wallet_provider.dart';
import 'package:viet_wallet/network/response/base_get_response.dart';
import 'package:viet_wallet/utilities/screen_utilities.dart';

import '../../network/response/get_list_category_response.dart';
import '../../network/response/get_list_wallet_response.dart';
import '../../utilities/enum/api_error_result.dart';
import 'planning_event.dart';
import 'planning_state.dart';

class PlanningBloc extends Bloc<PlanningEvent, PlanningState> {
  final BuildContext context;

  final _categoryProvider = CategoryProvider();

  PlanningBloc(this.context) : super(PlanningState()) {
    on((event, emit) async {
      if (event is InitialEvent) {
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
          final response = await WalletProvider().getListWallet();

          if (response is GetListWalletResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listWallet: response.walletList,
            ));
          } else if (response is ExpiredTokenGetResponse) {
            logoutIfNeed(this.context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listWallet: [],
            ));
          }

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

          final responseIncome =
              await _categoryProvider.getAllListCategory(param: "INCOME");
          if (responseIncome is GetCategoryResponse) {
            emit(
              state.copyWith(
                isLoading: false,
                apiError: ApiError.noError,
                listCoCategory: responseIncome.listCategory,
              ),
            );
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listCoCategory: [],
            ));
          }
        }
      }
    });
  }
}
