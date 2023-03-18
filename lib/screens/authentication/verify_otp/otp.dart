import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:viet_wallet/network/provider/auth_provider.dart';
import 'package:viet_wallet/screens/authentication/new_password/new_password.dart';
import 'package:viet_wallet/screens/authentication/new_password/new_password_bloc.dart';
import 'package:viet_wallet/screens/authentication/verify_otp/otp_event.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';
import 'package:viet_wallet/utilities/screen_utilities.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';
import 'package:viet_wallet/widgets/primary_button.dart';

import 'otp_bloc.dart';
import 'otp_state.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otpCode = '';
  int _timerCounter = 59;
  final focusNode = FocusNode();

  late OtpBloc _otpBloc;

  final _authProvider = AuthProvider();

  late Timer _timer;

  @override
  void initState() {
    _otpBloc = BlocProvider.of<OtpBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _otpBloc.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpBloc, OtpState>(
      listenWhen: (previousState, currentState) {
        return currentState.apiError != ApiError.noError;
      },
      listener: (context, state) {
        if (state.apiError == ApiError.internalServerError) {
          showCupertinoMessageDialog(
            context,
            'error',
            content: 'internal_server_error',
          );
        }
        if (state.apiError == ApiError.noInternetConnection) {
          showCupertinoMessageDialog(
            context,
            'error',
            content: 'no_internet_connection',
          );
        }
      },
      builder: (context, state) {
        Widget body = const SizedBox.shrink();
        if (state.isLoading) {
          body = const Scaffold(body: AnimationLoading());
        } else {
          body = _body(state);
        }
        return body;
      },
    );
  }

  Widget _body(OtpState state) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 24,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Verify OTP',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100, bottom: 50),
                      child: Text(
                        'We will send you onetime OTP code \non your email: ${widget.email}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    OtpTextField(
                      numberOfFields: 6,
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                      keyboardType: TextInputType.number,
                      borderWidth: 2,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderColor: Theme.of(context).primaryColor,
                      enabledBorderColor: Colors.grey,
                      disabledBorderColor: Colors.blue,
                      focusedBorderColor: Theme.of(context).primaryColor,
                      //autoFocus: true,
                      //set to true to show as box or false to show as dash
                      showFieldAsBox: true,
                      //runs when a code is typed in
                      onCodeChanged: (String code) {
                       // print(code);
                        //handle validation or checks here
                      },
                      //runs when every text field is filled
                      onSubmit: (String verificationCode) {
                        setState(() {
                          otpCode = verificationCode;
                          _otpBloc.add(Validate(isValidated: true));
                        });
                        // focusNode.requestFocus();
                        //todo:::
                        print(otpCode);
                      }, // end onSubmit
                    ),
                  ],
                ),
              ),
            ),
            _buttonVerify(state),
          ],
        ),
      ),
    );
  }

  Widget _buttonVerify(OtpState state) {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_timerCounter > 0) {
          setState(() {
            _timerCounter--;
          });
        } else {
          _timer.cancel();
        }
      },
    );
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(0.0),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Didn\'t receive code?',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () async {
                      ConnectivityResult connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult == ConnectivityResult.none &&
                          mounted) {
                        showMessageNoInternetDialog(context);
                      } else {
                        final response = _authProvider.forgotPassword(
                          // email: widget.email,
                          email: 'kulltran281199@gmail.com',
                        );
                        log(response.toString());
                      }
                    },
                    child: Text(
                      (_timerCounter == 0) ? 'Resend OTP' : '00:$_timerCounter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              height: 50,
              child: PrimaryButton(
                text: 'Verify',
                isDisable: !(state.isEnable),
                onTap: state.isEnable
                    ? () async {
                        ConnectivityResult connectivityResult =
                            await Connectivity().checkConnectivity();
                        if (connectivityResult == ConnectivityResult.none &&
                            mounted) {
                          showMessageNoInternetDialog(context);
                        } else {
                          _otpBloc.add(DisplayLoading());
                          final response = await _authProvider.verifyOtp(
                            // email: widget.email,
                            email: 'kulltran281199@gmail.com',
                            otpCode: otpCode,
                          );
                          //todo:::
                          print(response.toString());
                          if (response.isOK() && mounted) {
                            _otpBloc.add(OnSuccess());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => NewPasswordBloc(context),
                                  child: NewPasswordPage(
                                    email: widget.email,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            _otpBloc.add(
                              OnFailure(
                                errorMessage:
                                    response.errors?.first.errorMessage,
                              ),
                            );
                            showCupertinoMessageDialog(
                              context,
                              response.errors?.first.errorMessage,
                            );
                            _otpBloc.add(
                              Validate(
                                isValidated: false,
                              ),
                            );
                            setState(() {
                              otpCode = '';
                            });
                          }
                        }
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
