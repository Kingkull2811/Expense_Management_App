import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/model/analytic_model.dart';
import 'package:viet_wallet/network/response/base_response.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/year_analytic/year_analytic_event.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/year_analytic/year_analytic_state.dart';

import '../../../../network/provider/analytic_provider.dart';
import '../../../../utilities/enum/api_error_result.dart';
import '../../../../utilities/screen_utilities.dart';

class YearAnalyticBloc extends Bloc<YearAnalyticEvent, YearAnalyticState> {
  final BuildContext context;
  YearAnalyticBloc(this.context) : super(YearAnalyticState()) {
    on((event, emit) async {
      if (event is YearAnalyticEvent) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final Map<String, dynamic> query = {
            'fromTime': event.fromYear,
            'timeType': 'YEAR',
            'toTime': event.toYear,
            'type': 'EXPENSE'
          };

          final Map<String, dynamic> data = {
            if (event.walletIDs.isNotEmpty) 'walletIds': event.walletIDs,
            if (event.categoryIDs.isNotEmpty) 'categoryIds': event.categoryIDs,
          };

          log(query.toString());
          log(data.toString());

          final response = await AnalyticProvider().getDayEXAnalytic(
            query: query,
            data: data,
          );

          if (response is AnalyticModel) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              data: response,
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
