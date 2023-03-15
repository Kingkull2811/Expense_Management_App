import 'package:viet_wallet/bloc/api_result_state.dart';
import 'package:viet_wallet/network/response/error_response.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

class SignUpState implements ApiResultState {
  final bool isLoading;
  final String? message;
  final List<Errors>? errors;
  final ApiError _apiError;

  SignUpState({
    this.isLoading = false,
    this.message,
    this.errors,
    ApiError apiError = ApiError.noError,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension SignUpStateEx on SignUpState {
  SignUpState copyWith({
    ApiError? apiError,
    bool? isLoading,
    List<Errors>? errors,
    String? message,
  }) =>
      SignUpState(
        apiError: apiError ?? this.apiError,
        isLoading: isLoading ?? this.isLoading,
        message: message ?? this.message,
        errors: errors ?? this.errors,
      );
}
