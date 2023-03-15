import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_event.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final BuildContext context;

  SignUpBloc(this.context) : super(SignUpState()) {
    on((event, emit) async {
      if (event is Validate) {
        emit(
          state.copyWith(
            isLoading: false,
          ),
        );
      }
      if (event is SignUpLoading) {
        emit(
          state.copyWith(
            isLoading: true,
          ),
        );
      }
      if (event is SignUpSuccess) {
        emit(
          state.copyWith(
            isLoading: false,
            message: event.message,
          ),
        );
      }
      if (event is SignUpFailure) {
        emit(
          state.copyWith(
            isLoading: false,
            errors: event.errors,
          ),
        );
      }
    });
  }
}
