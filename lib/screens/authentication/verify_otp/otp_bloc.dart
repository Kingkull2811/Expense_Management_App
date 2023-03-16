import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/authentication/verify_otp/otp_event.dart';
import 'package:viet_wallet/screens/authentication/verify_otp/otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final BuildContext context;

  OtpBloc(this.context) : super(OtpState()) {
    on(
      (event, emit) async {
        if (event is Validate) {
          emit(
            state.copyWith(
              isEnable: event.isValidated,
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
