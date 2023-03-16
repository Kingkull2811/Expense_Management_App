import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/authentication/forgot_password/forgot_password_event.dart';
import 'package:viet_wallet/screens/authentication/forgot_password/forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final BuildContext context;

  ForgotPasswordBloc(this.context) : super(ForgotPasswordState()) {
    on((event, emit) async {
        if (event is Validate) {
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
        if (event is OnSuccess) {
          emit(
            state.copyWith(
              isLoading: false,
            ),
          );
        }
        if (event is OnFailure) {
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
