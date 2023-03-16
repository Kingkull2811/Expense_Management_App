import 'package:viet_wallet/bloc/api_result_state.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

class OtpState implements ApiResultState {
  final bool isLoading;
  final String? errorMessage;
  final ApiError _apiError;
  final bool isEnable;

  OtpState({
    ApiError apiError = ApiError.noError,
    this.isLoading = false,
    this.errorMessage,
    this.isEnable = false,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension OtpStateExtension on OtpState {
  OtpState copyWith({
    bool? isLoading,
    String? errorMessage,
    ApiError? apiError,
    bool? isEnable,
  }) =>
      OtpState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        apiError: apiError ?? this.apiError,
        isEnable: isEnable ?? this.isEnable,
      );
}
