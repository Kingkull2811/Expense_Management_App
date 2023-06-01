import 'package:viet_wallet/bloc/api_result_state.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

import '../../../network/model/wallet.dart';

class PaymentsPositionState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<Wallet>? listWallet;

  PaymentsPositionState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.listWallet,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension CategoryItemStateEx on PaymentsPositionState {
  PaymentsPositionState copyWith({
    bool? isLoading,
    ApiError? apiError,
    List<Wallet>? listWallet,
  }) =>
      PaymentsPositionState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listWallet: listWallet ?? this.listWallet,
      );
}
