import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/provider/category_provider.dart';
import 'package:viet_wallet/screens/planning/balance_payments/balance_payments_event.dart';
import 'package:viet_wallet/screens/planning/balance_payments/balance_payments_state.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

class PaymentsPositionBloc
    extends Bloc<PaymentsPositionEvent, PaymentsPositionState> {
  final BuildContext context;
  final _categoryProvider = CategoryProvider();

  PaymentsPositionBloc(this.context) : super(PaymentsPositionState()) {
    on<PaymentsPositionEvent>((event, emit) async {
      if (event is PaymentsPositionInit) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(
            state.copyWith(
              isLoading: false,
              apiError: ApiError.noInternetConnection,
            ),
          );
        } else {}
      }
    });
  }
}
