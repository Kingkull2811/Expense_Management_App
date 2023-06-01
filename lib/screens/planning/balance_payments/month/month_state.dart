import 'package:viet_wallet/bloc/api_result_state.dart';

import '../../../../network/model/report_expenditure_revenue_model.dart';
import '../../../../utilities/enum/api_error_result.dart';

class MonthAnalyticState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<ReportData>? data;

  MonthAnalyticState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.data,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension DayAnalyticStateEx on MonthAnalyticState {
  MonthAnalyticState copyWith({
    bool? isLoading,
    ApiError? apiError,
    List<ReportData>? data,
  }) =>
      MonthAnalyticState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        data: data ?? this.data,
      );
}
