import 'package:viet_wallet/bloc/api_result_state.dart';
import 'package:viet_wallet/network/model/wallet.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

class HomePageState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final int? moneyTotal;
  final List<Wallet>? listWallet;

  HomePageState({
    this.isLoading = true,
    ApiError apiError = ApiError.noError,
    this.moneyTotal,
    this.listWallet,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension HomePageStateEx on HomePageState {
  HomePageState copyWith({
    bool? isLoading,
    ApiError? apiError,
    int? moneyTotal,
    List<Wallet>? listWallet,
  }) =>
      HomePageState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        moneyTotal: moneyTotal ?? this.moneyTotal,
        listWallet: listWallet ?? listWallet,
      );
}
