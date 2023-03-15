import 'package:viet_wallet/bloc/api_result_state.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

class SignInState implements ApiResultState {
  final bool isLoading;

  /// status Authenticating Login
  final bool isAuthenticating;

  final String? errorMessage;
  final ApiError _apiError;

  SignInState({
    ApiError apiError = ApiError.noError,
    this.isLoading = false,
    this.isAuthenticating = false,
    this.errorMessage,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension SignInStateExtension on SignInState {
  SignInState copyWith({
    bool? isLoading,
    bool? isAuthenticating,
    String? errorMessage,
    ApiError? apiError,
  }) =>
      SignInState(
        isLoading: isLoading ?? this.isLoading,
        isAuthenticating: isAuthenticating ?? this.isAuthenticating,
        errorMessage: errorMessage ?? this.errorMessage,
        apiError: apiError ?? this.apiError,
      );
}
