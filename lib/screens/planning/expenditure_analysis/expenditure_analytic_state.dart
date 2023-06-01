import 'package:viet_wallet/bloc/api_result_state.dart';

import '../../../network/model/category_model.dart';
import '../../../network/model/wallet.dart';
import '../../../utilities/enum/api_error_result.dart';

class ExpenditureAnalyticState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<CategoryModel>? listExCategory;
  final List<Wallet>? listWallet;

  ExpenditureAnalyticState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.listExCategory,
    this.listWallet,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension ExpenditureAnalyticStateEx on ExpenditureAnalyticState {
  ExpenditureAnalyticState copyWith({
    bool? isLoading,
    ApiError? apiError,
    List<CategoryModel>? listExCategory,
    List<Wallet>? listWallet,
  }) =>
      ExpenditureAnalyticState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listExCategory: listExCategory ?? this.listExCategory,
        listWallet: listWallet ?? this.listWallet,
      );
}
