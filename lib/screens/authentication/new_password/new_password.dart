import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/provider/auth_provider.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_bloc.dart';
import 'package:viet_wallet/utilities/app_constants.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';
import 'package:viet_wallet/utilities/screen_utilities.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';
import 'package:viet_wallet/widgets/input_password_field.dart';
import 'package:viet_wallet/widgets/primary_button.dart';

import 'new_password_bloc.dart';
import 'new_password_event.dart';
import 'new_password_state.dart';

class NewPasswordPage extends StatefulWidget {
  final String email;
  const NewPasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final focusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isShowPassword = false;
  bool _isShowConfirmPassword = false;

  String messageValidate = '';
  bool hasCharacter = false;
  bool checkValidatePassword = false;

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
          showMessage1OptionDialog(
            context,
            'error',
            content: 'internal_server_error',
          );
        }
        if (state.apiError == ApiError.noInternetConnection) {
          showMessageNoInternetDialog(context);
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Mật khẩu mới',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Icon(
                          Icons.password_outlined,
                          size: 100,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'Thiết lập mật khẩu mới để hoàn tất khôi phục tài khoản của bạn',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 40,
                          right: 16,
                        ),
                        child: SizedBox(
                          height: 50,
                          child: InputPasswordField(
                            controller: _passwordController,
                            onChanged: (text) {},
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (_) {},
                            hint: 'Mật khẩu mới',
                            prefixIcon: Icons.lock_outline,
                            isInputError: false,
                            obscureText: !_isShowPassword,
                            onTapSuffixIcon: () {
                              setState(() {
                                _isShowPassword = !_isShowPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, top: 20, right: 16),
                        child: SizedBox(
                          height: 50,
                          child: InputPasswordField(
                            controller: _confirmPasswordController,
                            onChanged: (text) {},
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (_) {},
                            hint: 'Xác nhận mật khẩu mới',
                            prefixIcon: Icons.lock_outline,
                            isInputError: false,
                            obscureText: !_isShowConfirmPassword,
                            onTapSuffixIcon: () {
                              setState(() {
                                _isShowConfirmPassword =
                                    !_isShowConfirmPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.only(left: 16, top: 16, right: 16),
                      //   child: !hasCharacter
                      //       ? const SizedBox()
                      //       : checkValidatePassword
                      //           ? Row(
                      //               crossAxisAlignment: CrossAxisAlignment.center,
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               children: const [
                      //                 Icon(
                      //                   Icons.task_alt,
                      //                   size: 20,
                      //                   color: Colors.green,
                      //                 ),
                      //               ],
                      //             )
                      //           : Row(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [
                      //                 const Icon(
                      //                   Icons.cancel_outlined,
                      //                   size: 20,
                      //                   color: Colors.red,
                      //                 ),
                      //                 Container(
                      //                   width: MediaQuery.of(context).size.width -
                      //                       16 * 4 -
                      //                       20 -
                      //                       10,
                      //                   padding: const EdgeInsets.only(left: 10),
                      //                   child: Text(
                      //                     messageValidate,
                      //                     style: const TextStyle(
                      //                       fontSize: 16,
                      //                       color: Colors.red,
                      //                     ),
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      // ),
                    ],
                  ),
                ),
              ),
              _buttonSendCode()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonSendCode() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: PrimaryButton(
        text: 'Thiết lập',
        onTap: () async {
          if (_passwordController.text.isEmpty) {
            showMessage1OptionDialog(context, 'Mật khẩu không được trống');
          } else if (_confirmPasswordController.text.isEmpty) {
            showMessage1OptionDialog(
                context, 'Xác nhận mật khẩu không được trống');
          } else if (_confirmPasswordController.text !=
              _passwordController.text) {
            showMessage1OptionDialog(
                context, 'Mật khẩu và xác nhận mật khẩu không khớp');
          } else {
            final connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult == ConnectivityResult.none && mounted) {
              showMessageNoInternetDialog(context);
            } else {
              _newPasswordBloc.add(DisplayLoading());
              final response = await _authProvider.newPassword(
                email: widget.email,
                // email: 'kulltran281199@gmail.com',
                password: _passwordController.text.trim(),
                confirmPassword: _confirmPasswordController.text.trim(),
              );
              log(response.toString());
              if (response.isOK() && mounted) {
                _newPasswordBloc.add(OnSuccess());
                await showCupertinoAlertDialog(
                  context,
                  content: AppConstants.set_new_password_success,
                  barrierDismiss: false,
                  buttonLabel: 'Đăng nhập',
                  onClose: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => SignInBloc(context),
                          child: const SignInPage(),
                        ),
                      ),
                    );
                  },
                );
              }
            }
          }
        },
      ),
    );
  }

  bool _validatePassword() {
    // RegExp passwordExp =
    //     RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
    if (_passwordController.text.isEmpty &&
        _confirmPasswordController.text.isEmpty) {
      messageValidate = 'Mật khẩu không được trống';
      return false;
    }
    if (_passwordController.text.length < 6 &&
        _confirmPasswordController.text.length < 6 &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty) {
      messageValidate = 'Mật khẩu phải ≥ 6 ký tự';
      return false;
    }

    if (_passwordController.text.trim() !=
            _confirmPasswordController.text.trim() &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty) {
      messageValidate = 'Mật khẩu và xác nhận mật khẩu không khớp';
      return false;
    }

    return true;
  }
}
