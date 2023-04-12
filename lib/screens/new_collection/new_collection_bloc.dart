import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../network/provider/category_provider.dart';
import '../../network/response/get_category_response.dart';
import '../../utilities/screen_utilities.dart';
import 'new_collection_event.dart';
import 'new_collection_state.dart';

class NewCollectionBloc extends Bloc<NewCollectionEvent, NewCollectionState> {
  final CategoryProvider _categoryProvider = CategoryProvider();

  NewCollectionBloc(BuildContext context) : super(NewCollectionState()) {
    on((event, emit) async {
      if (event is GetListContentCategory) {
        ConnectivityResult connectivityResult =
            await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          await showMessageNoInternetDialog(context);
        } else {
          emit(
            state.copyWith(
              isLoading: true,
            ),
          );
          final response = await _categoryProvider.getListCategory();
          log('content category: ${response.toString()}');
          if (response is GetCategoryResponse) {
            emit(state.copyWith(
              isLoading: false,
              listContentCategory: response.listCategory,
            ));
          }
        }
      }
    });
  }
}
