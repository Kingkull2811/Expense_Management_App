import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/provider/auth_provider.dart';
import 'package:viet_wallet/network/response/error_response.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_event.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_state.dart';
import 'package:viet_wallet/utilities/app_constants.dart';
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
  bool _isShowPassword = false;
  bool _isShowConfirmPassword = false;

  String messageValidate = '';
  String messageValidateEmail = '';
  bool hasCharacter = false;
  bool checkValidate = false;
  bool errorEmail = false;
  bool errorPassword = false;

  late SignUpBloc _signUpBloc;

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
          showMessage1OptionDialog(context, 'Error!',
              content: 'Internal_server_error');
        }
        if (curState.apiError == ApiError.noInternetConnection) {
          showMessage1OptionDialog(context, 'Error!',
              content: 'No_internet_connection');
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
                  child: Column(
                    children: [
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
                        onSubmit: (_) => focusNode.requestFocus(),
                      ),
                      _inputTextField(
                        hintText: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.mail_outline,
                        onSubmit: (value) {
                          focusNode.requestFocus();
                          if (_emailController.text.isNotEmpty &&
                              !(AppConstants.emailExp)
                                  .hasMatch(_emailController.text.trim())) {
                            setState(() {
                              errorEmail = true;
                              hasCharacter = true;
                              messageValidateEmail =
                                  'Địa chỉ email không đúng đinh dạng';
                            });
                          }
                        },
                        isEmailError: errorEmail,
                      ),
                      _passwordField(
                        hintText: 'Password',
                        controller: _passwordController,
                        obscureText: !_isShowPassword,
                        onSubmit: (value) => focusNode.requestFocus(),
                        //   // setState(() {
                        //   //   hasCharacter = true;
                        //   //   errorPassword = !checkValidate;
                        //   // });
                        // },
                        isPasswordError: hasCharacter
                            ? errorPassword
                                ? true
                                : false
                            : false,
                        onTapSuffixIcon: () {
                          setState(() {
                            _isShowPassword = !_isShowPassword;
                          });
                        },
                      ),
                      _passwordField(
                        hintText: 'Confirm Password',
                        controller: _confirmPasswordController,
                        obscureText: !_isShowConfirmPassword,
                        isPasswordError: hasCharacter
                            ? errorPassword
                                ? true
                                : false
                            : false,
                        onTapSuffixIcon: () {
                          setState(() {
                            _isShowConfirmPassword = !_isShowConfirmPassword;
                          });
                        },
                        onSubmit: (value) {
                          focusNode.requestFocus();
                          setState(() {
                            hasCharacter = true;
                            checkValidate = _validatePassword();
                            errorPassword = !checkValidate;
                          });
                        },
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: !hasCharacter
                            ? const SizedBox()
                            : !errorEmail
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(
                                        Icons.task_alt,
                                        size: 20,
                                        color: Colors.green,
                                      ),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.cancel_outlined,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                16 * 4 -
                                                20 -
                                                10,
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          messageValidateEmail,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: !hasCharacter
                            ? const SizedBox()
                            : checkValidate
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(
                                        Icons.task_alt,
                                        size: 20,
                                        color: Colors.green,
                                      ),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.cancel_outlined,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                16 * 4 -
                                                20 -
                                                10,
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          messageValidate,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                      ),
                    ],
                  ),
                ),
                _buttonSignUp(state)
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
    Function(String)? onSubmit,
    bool isEmailError = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: SizedBox(
        height: 50,
        child: Input(
          isInputError: isEmailError,
          keyboardType: keyboardType,
          controller: controller,
          onChanged: (text) {},
          textInputAction: TextInputAction.next,
          onSubmit: onSubmit,
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
    Function(String)? onSubmit,
    Function? validator,
    bool isPasswordError = false,
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
          isInputError: isPasswordError,
          onTapSuffixIcon: onTapSuffixIcon,
          onFieldSubmitted: onSubmit,
          hint: hintText,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          prefixIcon: Icons.lock_outline,
        ),
      ),
    );
  }

  Widget _buttonSignUp(SignUpState currentState) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: PrimaryButton(
        text: 'Sign Up',
        isDisable: !checkValidate,
        onTap: checkValidate
            ? () async {
                ConnectivityResult connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.none && mounted) {
                  showMessageNoInternetDialog(context);
                } else {
                  _signUpBloc.add(SignUpLoading());

                  final response = await _authProvider.signUp(
                    // email: 'truong4@gmail.com',
                    // password: '123456',
                    // username: 'truong4',
                    email: _emailController.text.trim(),
                    username: _usernameController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                  if (response.isOK() && mounted) {
                    // _signUpBloc.add(
                    //   SignUpSuccess(message: response.message ?? ''),
                    // );
                    showSuccessBottomSheet(
                      context,
                      isDismissible: true,
                      enableDrag: true,
                      titleMessage: response.message,
                      contentMessage: 'Vui lòng đăng nhập lại',
                      buttonLabel: 'Đăng nhập',
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
                    // _signUpBloc.add(
                    //   SignUpFailure(errors: response.errors),
                    // );

                    String? errorMessage = '';
                    List<Errors>? errors = response.errors;
                    for (var error in errors!) {
                      errorMessage = '$errorMessage\n${error.errorMessage}';
                    }
                    showMessage1OptionDialog(
                      context,
                      errorMessage,
                    );
                  }
                }
              }
            : null,
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

  bool _validatePassword() {
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
