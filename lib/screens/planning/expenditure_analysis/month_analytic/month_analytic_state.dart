import 'package:viet_wallet/bloc/api_result_state.dart';

import '../../../../network/model/analytic_model.dart';
import '../../../../utilities/enum/api_error_result.dart';

class MonthAnalyticState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final AnalyticModel? data;

  MonthAnalyticState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.data,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension MonthAnalyticStateEx on MonthAnalyticState {
  MonthAnalyticState copyWith({
    bool? isLoading,
    ApiError? apiError,
    AnalyticModel? data,
  }) =>
      MonthAnalyticState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        data: data ?? this.data,
      );
}
