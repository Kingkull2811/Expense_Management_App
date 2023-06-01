import 'package:viet_wallet/bloc/api_result_state.dart';

import '../../../../network/model/analytic_model.dart';
import '../../../../utilities/enum/api_error_result.dart';

class CurrentAnalyticState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final AnalyticModel? data;

  CurrentAnalyticState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.data,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension DayAnalyticStateEx on CurrentAnalyticState {
  CurrentAnalyticState copyWith({
    bool? isLoading,
    ApiError? apiError,
    AnalyticModel? data,
  }) =>
      CurrentAnalyticState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        data: data ?? this.data,
      );
}
