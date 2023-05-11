import 'package:viet_wallet/bloc/api_result_state.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

import '../../../network/model/category_model.dart';

class PaymentsPositionState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<CategoryModel>? listExCategory;
  final List<CategoryModel>? listCoCategory;

  PaymentsPositionState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.listExCategory,
    this.listCoCategory,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension CategoryItemStateEx on PaymentsPositionState {
  PaymentsPositionState copyWith({
    bool? isLoading,
    ApiError? apiError,
    List<CategoryModel>? listExCategory,
    List<CategoryModel>? listCoCategory,
  }) =>
      PaymentsPositionState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listExCategory: listExCategory ?? this.listExCategory,
        listCoCategory: listCoCategory ?? this.listCoCategory,
      );
}
