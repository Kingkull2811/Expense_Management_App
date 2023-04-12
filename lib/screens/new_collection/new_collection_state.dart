import '../../bloc/api_result_state.dart';
import '../../network/model/category_model.dart';
import '../../utilities/enum/api_error_result.dart';

class NewCollectionState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<ContentItem>? listContentCategory;

  NewCollectionState({
    ApiError apiError = ApiError.noError,
    this.isLoading = false,
    this.listContentCategory,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension NewCollectionStateExtension on NewCollectionState {
  NewCollectionState copyWith({
    bool? isLoading,
    ApiError? apiError,
    List<ContentItem>? listContentCategory,
  }) =>
      NewCollectionState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listContentCategory: listContentCategory ?? this.listContentCategory,
      );
}
