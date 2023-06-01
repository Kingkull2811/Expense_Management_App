import 'package:viet_wallet/bloc/api_result_state.dart';

import '../../../../network/model/report_expenditure_revenue_model.dart';
import '../../../../utilities/enum/api_error_result.dart';

class CurrentAnalyticState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<ReportData>? data;

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
    List<ReportData>? data,
  }) =>
      CurrentAnalyticState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        data: data ?? this.data,
      );
}
