

import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/provider/auth_provider.dart';
import 'package:viet_wallet/utilities/app_constants.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';
import 'package:viet_wallet/utilities/screen_utilities.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';
import 'package:viet_wallet/widgets/input_field.dart';
import 'package:viet_wallet/widgets/primary_button.dart';

import 'new_password_bloc.dart';
import 'new_password_event.dart';
import 'new_password_state.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({Key? key}) : super(key: key);

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final focusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late NewPasswordBloc _newPasswordBloc;

  final _authProvider = AuthProvider();

  @override
  void initState() {
    _newPasswordBloc = BlocProvider.of<NewPasswordBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewPasswordBloc, NewPasswordState>(
      listenWhen: (previousState, currentState) {
        return currentState.apiError != ApiError.noError;
      },
      listener: (context, state) {
        if (state.apiError == ApiError.internalServerError) {
          showCupertinoMessageDialog(
            context,
            'error',
            'internal_server_error',
          );
        }
        if (state.apiError == ApiError.noInternetConnection) {
          showCupertinoMessageDialog(
            context,
            'error',
            'no_internet_connection',
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

  Widget _body(NewPasswordState state) {
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
          'Set new Password',
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
                    const Text('sett a new password',
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
                          textInputAction: TextInputAction.send,
                          controller: _passwordController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          onSubmit: (_) => focusNode.requestFocus(),
                          prefixIcon: Icons.lock_outline,
                          hint: 'Enter your new password',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: SizedBox(
                        height: 50,
                        child: Input(
                          textInputAction: TextInputAction.send,
                          controller: _confirmPasswordController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          onSubmit: (_) => focusNode.requestFocus(),
                          prefixIcon: Icons.lock_outline,
                          hint: 'Confirm your new password',
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
        text: 'Set a new password',
        // isDisable: _emailController.text.isEmpty,
        onTap:
            //_emailController.text.isEmpty ? null :
            () async {
          ConnectivityResult connectivityResult =
              await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none && mounted) {
            showMessageNoInternetDialog(context);
          } else {
            _newPasswordBloc.add(DisplayLoading());
            final response = _authProvider.forgotPassword(
                // email: _emailController.text.trim(),
                email: 'kulltran281199@gmail.com');
            log(response.toString());
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => BlocProvider<OtpBloc>(
            //       create: (context) => OtpBloc(context),
            //       child: OtpPage(
            //         email: _emailController.text.trim(),
            //       ),
            //     ),
            //   ),
            // );
          }
        },
      ),
    );
  }
}
