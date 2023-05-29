import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/provider/category_provider.dart';
import 'package:viet_wallet/network/provider/wallet_provider.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/expenditure_analysis_event.dart';
import 'package:viet_wallet/screens/planning/expenditure_analysis/expenditure_analysis_state.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

class ExpenditureBloc extends Bloc<ExpenditureEvent, ExpenditureState> {
  final BuildContext context;
  final _categoryProvider = CategoryProvider();
  final _walletProvider = WalletProvider();
  ExpenditureBloc(this.context) : super(ExpenditureState()) {
    on<ExpenditureEvent>((event, emit) async {
      if (event is ExpenditureInit) {
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
