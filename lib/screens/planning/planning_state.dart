import '../../bloc/api_result_state.dart';
import '../../network/model/category_model.dart';
import '../../network/model/wallet.dart';
import '../../utilities/enum/api_error_result.dart';

class PlanningState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<Wallet>? listWallet;
  final List<CategoryModel>? listExCategory;
  final List<CategoryModel>? listCoCategory;

  PlanningState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.listWallet,
    this.listExCategory,
    this.listCoCategory,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension PlanningStateEx on PlanningState {
  PlanningState copyWith(
          {bool? isLoading,
          ApiError? apiError,
          List<Wallet>? listWallet,
          List<CategoryModel>? listExCategory,
          List<CategoryModel>? listCoCategory}) =>
      PlanningState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listWallet: listWallet ?? this.listWallet,
        listExCategory: listExCategory ?? this.listExCategory,
        listCoCategory: listCoCategory ?? this.listCoCategory,
      );
}
