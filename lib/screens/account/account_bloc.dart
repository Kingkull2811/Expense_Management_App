import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState>{
  AccountBloc(BuildContext context): super(AccountState()){
    on((event, emit) async{

    });
  }
}