import 'package:viet_wallet/bloc/api_result_state.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

import '../../../network/model/wallet_report_model.dart';

class WalletDetailsState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final WalletReport? walletReport;

  WalletDetailsState({
    ApiError apiError = ApiError.noError,
    this.isLoading = false,
    this.walletReport,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension WalletDetailsStateExtension on WalletDetailsState {
  WalletDetailsState copyWith({
    bool? isLoading,
    ApiError? apiError,
    WalletReport? walletReport,
  }) =>
      WalletDetailsState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        walletReport: walletReport ?? this.walletReport,
      );
}
