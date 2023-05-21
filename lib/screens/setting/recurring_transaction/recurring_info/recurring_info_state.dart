import 'package:viet_wallet/bloc/api_result_state.dart';

import '../../../../network/model/category_model.dart';
import '../../../../network/model/wallet.dart';
import '../../../../utilities/enum/api_error_result.dart';

class RecurringInfoState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<CategoryModel>? listExCategory;
  final List<Wallet>? listWallet;
  final bool addSuccess;

  RecurringInfoState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.listExCategory,
    this.listWallet,
    this.addSuccess = false,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension RecurringInfoStateEx on RecurringInfoState {
  RecurringInfoState copyWith({
    bool? isLoading,
    ApiError? apiError,
    List<CategoryModel>? listExCategory,
    List<Wallet>? listWallet,
    bool? addSuccess,
  }) =>
      RecurringInfoState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listExCategory: listExCategory ?? this.listExCategory,
        listWallet: listWallet ?? this.listWallet,
        addSuccess: addSuccess ?? this.addSuccess,
      );
}
