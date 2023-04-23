import '../../bloc/api_result_state.dart';
import '../../utilities/enum/api_error_result.dart';

class NewCollectionState implements ApiResultState {
  final bool isLoading;
  final bool isNoInternet;
  final ApiError _apiError;

  NewCollectionState({
    ApiError apiError = ApiError.noError,
    this.isLoading = false,
    this.isNoInternet = false,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension NewCollectionStateExtension on NewCollectionState {
  NewCollectionState copyWith({
    bool? isLoading,
    bool? isNoInternet,
    ApiError? apiError,
  }) =>
      NewCollectionState(
        isLoading: isLoading ?? this.isLoading,
        isNoInternet: isNoInternet ?? this.isNoInternet,
        apiError: apiError ?? this.apiError,
      );
}
