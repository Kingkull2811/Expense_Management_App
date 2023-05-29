import '../../../../bloc/api_result_state.dart';
import '../../../../utilities/enum/api_error_result.dart';

class DayAnalyticState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;

  DayAnalyticState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension DayAnalyticStateEx on DayAnalyticState {
  DayAnalyticState copyWith({
    bool? isLoading,
    ApiError? apiError,
  }) =>
      DayAnalyticState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
      );
}
