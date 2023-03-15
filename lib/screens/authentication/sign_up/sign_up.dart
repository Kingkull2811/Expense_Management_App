import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/provider/auth_provider.dart';
import 'package:viet_wallet/network/repository/auth_repository.dart';
import 'package:viet_wallet/network/response/base_response.dart';
import 'package:viet_wallet/network/response/error_response.dart';
import 'package:viet_wallet/network/response/sign_up_response.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_event.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_state.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';
import 'package:viet_wallet/widgets/input_password_field.dart';

import '../../../utilities/screen_utilities.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/primary_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final focusNode = FocusNode();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isShow = false;
  bool _isShowConfirm = false;

  late SignUpBloc _signUpBloc;

  final _authRepository = AuthRepository();
  final _authProvider = AuthProvider();

  @override
  void initState() {
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _signUpBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, curState) {
        if (curState.apiError == ApiError.internalServerError) {
          showCupertinoMessageDialog(
              context, 'Error!', 'Internal_server_error');
        }
        if (curState.apiError == ApiError.noInternetConnection) {
          showCupertinoMessageDialog(
              context, 'Error!', 'No_internet_connection');
        }
      },
      builder: (context, curState) {
        Widget body = const SizedBox.shrink();
        if (curState.isLoading) {
          body = const AnimationLoading();
        } else {
          body = _body(curState);
        }

        return Scaffold(body: body);
      },
    );
  }

  Widget _body(SignUpState state) {
    final height = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;

    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              top: padding.top,
              right: 16,
              bottom: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: height - 120,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/logo_app.png',
                            height: 150,
                            width: 150,
                            color: Theme.of(context).primaryColor,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              'Welcome signup to \'app name\'',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _inputTextField(
                      hintText: 'Username',
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      prefixIcon: Icons.person_outline,
                    ),
                    _inputTextField(
                      hintText: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.text,
                      prefixIcon: Icons.mail_outline,
                    ),
                    _passwordField(
                      hintText: 'Password',
                      controller: _passwordController,
                      obscureText: !_isShow,
                      onTapSuffixIcon: () {
                        setState(() {
                          _isShow = !_isShow;
                        });
                      },
                    ),
                    _passwordField(
                      hintText: 'Confirm Password',
                      controller: _confirmPasswordController,
                      obscureText: !_isShowConfirm,
                      onTapSuffixIcon: () {
                        setState(() {
                          _isShowConfirm = !_isShowConfirm;
                        });
                      },
                      validator: (text) {},
                    ),
                  ]),
                ),
                _buttonSendOTP(
                  state,
                  _usernameController.text,
                )
              ],
            ),
          ),
          _goToSignInPage(),
        ],
      ),
    );
  }

  Widget _inputTextField({
    required String hintText,
    required TextEditingController controller,
    required TextInputType keyboardType,
    IconData? prefixIcon,
    String? prefixIconPath,
    int? maxText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: SizedBox(
        height: 50,
        child: Input(
          keyboardType: keyboardType,
          maxText: maxText,
          controller: controller,
          onChanged: (text) {
            //_validateForm();
          },
          textInputAction: TextInputAction.next,
          onSubmit: (_) => focusNode.requestFocus(),
          hint: hintText,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }

  Widget _passwordField({
    String? hintText,
    Function? onTapSuffixIcon,
    required TextEditingController controller,
    bool obscureText = false,
    Function? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
      child: SizedBox(
        height: 50,
        child: InputPasswordField(
          validator: validator,
          controller: controller,
          onChanged: (text) {},
          obscureText: obscureText,
          isInputError: false,
          onTapSuffixIcon: onTapSuffixIcon,
          onFieldSubmitted: (_) => focusNode.requestFocus(),
          hint: hintText,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          prefixIcon: Icons.lock_outline,
        ),
      ),
    );
  }

  Widget _buttonSendOTP(SignUpState currentState, String phoneNumber) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: PrimaryButton(
        text: 'Sign Up',
        onTap: () async {
          ConnectivityResult connectivityResult =
              await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none && mounted) {
            showMessageNoInternetDialog(context);
          } else {
            _signUpBloc.add(SignUpLoading());
            //  final signUpResult = _authRepository.signUp(
            //      email: _emailController.text.trim(),
            //      username: _usernameController.text.trim(),
            //      password: _passwordController.text.trim(),
            // );
            BaseResponse response = await _authProvider.signUp(
              email: 'truong4@gmail.com',
              password: '123456',
              username: 'truong4',
              // email: _emailController.text.trim(),
              // username: _usernameController.text.trim(),
              // password: _passwordController.text.trim(),
            );
            if (response.httpStatus == 200 && mounted) {
              _signUpBloc.add(
                SignUpSuccess(message: response.message ?? ''),
              );
              showSuccessBottomSheet(
                context,
                isDismissible: true,
                enableDrag: true,
                titleMessage: response.message,
                contentMessage: 'Vui lòng đăng nhập lại',
                buttonLabel: 'Login',
                onTap: () {
                  Navigator.push(
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
            } else {
              _signUpBloc.add(
                SignUpFailure(errors: response.errors),
              );
              String? errorMessage = '';
              List<Errors>? errors = response.errors;
              for (var error in errors!) {
                errorMessage = '$errorMessage\n${error.errorMessage}';
              }
            }
          }
        },
      ),
    );
  }

  Widget _goToSignInPage() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account? ',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<SignInBloc>(
                    create: (context) => SignInBloc(context),
                    child: const SignInPage(),
                  ),
                ),
              );
            },
            child: Text(
              'Sign In',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        ],
      ),
    );
  }
}
