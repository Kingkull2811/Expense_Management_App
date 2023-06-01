import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/response/base_response.dart';
import 'package:viet_wallet/screens/planning/balance_payments/precious/precious_event.dart';

import '../../../../network/provider/analytic_provider.dart';
import '../../../../network/response/report_expenditure_revenue_response.dart';
import '../../../../utilities/enum/api_error_result.dart';
import '../../../../utilities/screen_utilities.dart';
import 'precious_state.dart';

class PreciousAnalyticBloc
    extends Bloc<PreciousAnalyticEvent, PreciousAnalyticState> {
  final BuildContext context;
  PreciousAnalyticBloc(this.context) : super(PreciousAnalyticState()) {
    on((event, emit) async {
      if (event is PreciousAnalyticEvent) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final Map<String, dynamic> query = {
            'type': 'QUARTER',
          };

          final Map<String, dynamic> data = {
            if (event.walletIDs.isNotEmpty) 'walletIds': event.walletIDs,
          };

          final response = await AnalyticProvider().getBalanceAnalytic(
            query: query,
            data: data,
          );

          if (response is ReportDataResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              data: response.data,
            ));
          } else if (response is ExpiredTokenResponse) {
            logoutIfNeed(this.context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
            ));
          }
        }
      }
    });
  }
}
