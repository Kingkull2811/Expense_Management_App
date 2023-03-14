import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_event.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState>{
    final BuildContext context;
    SignUpBloc(this.context):super(SignUpState()){
      on((event, emit) async{

      });
    }
}