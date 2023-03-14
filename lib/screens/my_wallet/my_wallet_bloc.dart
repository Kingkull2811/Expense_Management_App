import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'my_wallet_event.dart';
import 'my_wallet_state.dart';

class MyWalletPageBloc extends Bloc<MyWalletPageEvent, MyWalletPageState>{
MyWalletPageBloc(BuildContext context): super(MyWalletPageState()){
    on((event, emit) async{

    });
  }
}