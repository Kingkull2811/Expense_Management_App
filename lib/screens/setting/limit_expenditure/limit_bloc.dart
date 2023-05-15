import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/response/list_limit_response.dart';

import '../../../network/provider/limit_provider.dart';
import '../../../network/response/base_get_response.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import 'limit_event.dart';
import 'limit_state.dart';

class LimitBloc extends Bloc<LimitEvent, LimitState> {
  final BuildContext context;

  final _limitProvider = LimitProvider();
  LimitBloc(this.context) : super(LimitState()) {
    on((event, emit) async {
      if (event is GetListLimitEvent) {
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
          final response = await _limitProvider.getListLimit();
          if (response is ListLimitResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listLimit: response.listLimit,
            ));
          } else if (response is ExpiredTokenGetResponse) {
            logoutIfNeed(this.context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listLimit: [],
            ));
          }
        }
      }
    });
  }
}
