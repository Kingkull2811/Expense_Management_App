import 'package:viet_wallet/bloc/api_result_state.dart';

import '../../../../network/model/limit_expenditure_model.dart';
import '../../../../utilities/enum/api_error_result.dart';

class ReportLimitState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final LimitModel? limitData;

  ReportLimitState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.limitData,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension ReportLimitStateEx on ReportLimitState {
  ReportLimitState copyWith({
    bool? isLoading,
    ApiError? apiError,
    LimitModel? limitData,
  }) =>
      ReportLimitState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        limitData: limitData ?? this.limitData,
      );
}
