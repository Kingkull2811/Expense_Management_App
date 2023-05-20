import 'package:viet_wallet/bloc/api_result_state.dart';
import 'package:viet_wallet/network/model/category_model.dart';
import 'package:viet_wallet/network/model/wallet.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

class ExpenditureState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<CategoryModel>? listExCategory;
  final List<CategoryModel>? listCoCategory;
  final List<Wallet>? listWallet;

  ExpenditureState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.listExCategory,
    this.listCoCategory,
    this.listWallet,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension CategoryItemStateEx on ExpenditureState {
  ExpenditureState copyWith({
    bool? isLoading,
    ApiError? apiError,
    List<CategoryModel>? listExCategory,
    List<CategoryModel>? listCoCategory,
    List<Wallet>? listWallet,
  }) =>
      ExpenditureState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listExCategory: listExCategory ?? this.listExCategory,
        listCoCategory: listCoCategory ?? this.listCoCategory,
        listWallet: listWallet ?? this.listWallet,
      );
}
