import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/response/base_response.dart';
import 'package:viet_wallet/network/response/limit_by_id_response.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/report_limit/report_limit_event.dart';
import 'package:viet_wallet/utilities/screen_utilities.dart';

import '../../../../network/provider/limit_provider.dart';
import '../../../../utilities/enum/api_error_result.dart';
import 'report_limit_state.dart';

class ReportLimitBloc extends Bloc<ReportLimitEvent, ReportLimitState> {
  final BuildContext context;

  final _limitProvider = LimitProvider();
  ReportLimitBloc(this.context) : super(ReportLimitState()) {
    on((event, emit) async {
      if (event is Initial) {
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
          final response = await _limitProvider.getListLimitByID(
            event.reportLimitId,
          );

          if (response is LimitByIDResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              limitData: response.data,
            ));
          } else if (response is ExpiredTokenResponse) {
            logoutIfNeed(this.context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              limitData: null,
            ));
          }
        }
      }
    });
  }
}
