import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/provider/auth_provider.dart';
import 'package:viet_wallet/network/response/forgot_password_response.dart';
import 'package:viet_wallet/screens/authentication/verify_otp/otp.dart';
import 'package:viet_wallet/screens/authentication/verify_otp/otp_bloc.dart';
import 'package:viet_wallet/utilities/app_constants.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';
import 'package:viet_wallet/utilities/screen_utilities.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';
import 'package:viet_wallet/widgets/input_field.dart';
import 'package:viet_wallet/widgets/primary_button.dart';

import 'forgot_password_bloc.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final focusNode = FocusNode();
  final _emailController = TextEditingController();

  late ForgotPasswordBloc _forgotPasswordBloc;

  final _authProvider = AuthProvider();

  @override
  void initState() {
    _forgotPasswordBloc = BlocProvider.of<ForgotPasswordBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _forgotPasswordBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
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

  Widget _body(ForgotPasswordState state) {
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
          'Forgot Password',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 80, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      AppConstants.forgotPassword,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 80, right: 16),
                      child: SizedBox(
                        height: 50,
                        child: Input(
                          textInputAction: TextInputAction.done,
                          controller: _emailController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          onSubmit: (_) => focusNode.requestFocus(),
                          prefixIcon: Icons.mail_outline,
                          hint: 'Enter your email',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buttonSendCode()
          ],
        ),
      ),
    );
  }

  Widget _buttonSendCode() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: PrimaryButton(
        text: 'Send me Code',
        // isDisable: _emailController.text.isEmpty,
        onTap:
            //_emailController.text.isEmpty ? null :
            () async {
          ConnectivityResult connectivityResult =
              await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none && mounted) {
            showMessageNoInternetDialog(context);
          } else {
            _forgotPasswordBloc.add(DisplayLoading());
            ForgotPasswordResponse response = await _authProvider
                .forgotPassword(email: _emailController.text.trim());
            // email: 'kulltran281199@gmail.com');
            // log(response.toString());
            if (response.httpStatus == 200 && mounted) {
              _forgotPasswordBloc.add(OnSuccess());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<OtpBloc>(
                    create: (context) => OtpBloc(context),
                    child: OtpPage(
                      email: _emailController.text.trim(),
                    ),
                  ),
                ),
              );
            } else {
              _forgotPasswordBloc.add(
                OnFailure(
                  errorMessage: response.errors?.first.errorMessage,
                ),
              );
              showCupertinoMessageDialog(
                context,
                response.errors?.first.errorMessage,
              );
            }
          }
        },
      ),
    );
  }
}
