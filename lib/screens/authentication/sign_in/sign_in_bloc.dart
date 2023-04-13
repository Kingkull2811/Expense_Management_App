import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_event.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final BuildContext context;

  SignInBloc(this.context) : super(SignInState()) {
    on(
      (event, emit) async {
        if (event is ValidateForm) {
          emit(
            state.copyWith(
              isLoading: false,
            ),
          );
        }
        if (event is DisplayLoading) {
          emit(
            state.copyWith(
              isLoading: true,
            ),
          );
        }
        if (event is SignInSuccess) {
          emit(
            state.copyWith(
              isLoading: false,
            ),
          );
        }
        if (event is SignInFailure) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: event.errorMessage,
            ),
          );
        }
      },
    );
  }
}
