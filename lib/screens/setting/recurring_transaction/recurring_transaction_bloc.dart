import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/response/base_get_response.dart';
import 'package:viet_wallet/network/response/recurring_response.dart';
import 'package:viet_wallet/screens/setting/recurring_transaction/recurring_transaction_event.dart';
import 'package:viet_wallet/screens/setting/recurring_transaction/recurring_transaction_state.dart';

import '../../../network/repository/recurring_repository.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/enum/enum.dart';
import '../../../utilities/screen_utilities.dart';

class RecurringTransactionBloc
    extends Bloc<RecurringTransactionEvent, RecurringTransactionState> {
  final BuildContext context;

  final _recurringRepository = RecurringRepository();

  RecurringTransactionBloc(this.context) : super(RecurringTransactionState()) {
    on((event, emit) async {
      if (event is RecurringInit) {
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
          final Map<String, dynamic> query = {
            'type': TransactionType.expense.name.toUpperCase(),
            'status': TransactionStatus.on_going.name.toUpperCase()
          };
          final response = await _recurringRepository.getListRecurring(
            event.query ?? query,
          );

          if (response is RecurringResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listRecurring: response.listRecurring,
            ));
          } else if (response is ExpiredTokenGetResponse) {
            logoutIfNeed(this.context);
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listRecurring: [],
            ));
          }
        }
      }
    });
  }
}
