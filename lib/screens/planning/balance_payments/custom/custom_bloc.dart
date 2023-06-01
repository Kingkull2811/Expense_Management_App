import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/response/base_response.dart';

import '../../../../network/provider/analytic_provider.dart';
import '../../../../network/response/report_expenditure_revenue_response.dart';
import '../../../../utilities/enum/api_error_result.dart';
import '../../../../utilities/screen_utilities.dart';
import 'custom_event.dart';
import 'custom_state.dart';

class CustomAnalyticBloc
    extends Bloc<CustomAnalyticEvent, CustomAnalyticState> {
  final BuildContext context;
  CustomAnalyticBloc(this.context) : super(CustomAnalyticState()) {
    on((event, emit) async {
      if (event is CustomAnalyticEvent) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final Map<String, dynamic> query = {
            'type': 'CUSTOM',
            'fromTime': event.fromTime,
            'toTime': event.toTime,
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
