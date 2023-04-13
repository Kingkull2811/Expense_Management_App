import 'package:viet_wallet/bloc/api_result_state.dart';

import '../../network/model/wallet.dart';
import '../../utilities/enum/api_error_result.dart';

class MyWalletPageState implements ApiResultState {
  final ApiError _apiError;
  final bool isLoading;
  final bool isNoInternet;
  final int? moneyTotal;
  final List<Wallet>? listWallet;

  MyWalletPageState({
    ApiError apiError = ApiError.noError,
    this.isNoInternet = false,
    this.isLoading = true,
    this.moneyTotal,
    this.listWallet,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension MyWalletPageStateEx on MyWalletPageState {
  MyWalletPageState copyWith({
    ApiError? apiError,
    bool? isLoading,
    bool? isNoInternet,
    int? moneyTotal,
    List<Wallet>? listWallet,
  }) =>
      MyWalletPageState(
        apiError: apiError ?? this.apiError,
        isNoInternet: isNoInternet ?? this.isNoInternet,
        isLoading: isLoading ?? this.isLoading,
        moneyTotal: moneyTotal ?? this.moneyTotal,
        listWallet: listWallet ?? this.listWallet,
      );
}
