import '../../bloc/api_result_state.dart';
import '../../network/model/wallet.dart';
import '../../utilities/enum/api_error_result.dart';

class NewCollectionState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<Wallet>? listWallet;

  NewCollectionState({
    ApiError apiError = ApiError.noError,
    this.isLoading = false,
    this.listWallet,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension NewCollectionStateExtension on NewCollectionState {
  NewCollectionState copyWith(
          {bool? isLoading, ApiError? apiError, List<Wallet>? listWallet}) =>
      NewCollectionState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listWallet: listWallet ?? this.listWallet,
      );
}
