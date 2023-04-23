import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'new_collection_event.dart';
import 'new_collection_state.dart';

class NewCollectionBloc extends Bloc<NewCollectionEvent, NewCollectionState> {


  NewCollectionBloc(BuildContext context) : super(NewCollectionState()) {
    on((event, emit) async {
      if (event is GetListContentCategory) {
        ConnectivityResult connectivityResult =
            await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(
            state.copyWith(
              isLoading: false,
              isNoInternet: true,
            ),
          );
        } else {
        }
      }
    });
  }
}
