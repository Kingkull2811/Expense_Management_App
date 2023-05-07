import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/provider/wallet_provider.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

import '../../network/response/get_list_wallet_response.dart';
import 'new_collection_event.dart';
import 'new_collection_state.dart';

class NewCollectionBloc extends Bloc<NewCollectionEvent, NewCollectionState> {
  final BuildContext context;

  final _walletProvider = WalletProvider();

  NewCollectionBloc(this.context) : super(NewCollectionState()) {
    on((event, emit) async {
      if (event is CollectionInit) {
        emit(state.copyWith(isLoading: true));

        final response = await _walletProvider.getListWallet();

        if (response is GetListWalletResponse) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noError,
            listWallet: response.walletList,
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.internalServerError,
            listWallet: [],
          ));
        }
      }
    });
  }
}
