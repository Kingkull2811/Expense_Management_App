import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/provider/auth_provider.dart';
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

  final _formKey = GlobalKey<FormState>();

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

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(body: body),
        );
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'images/logo_app.png',
                                height: 150,
                                width: 150,
                                color: Theme.of(context).primaryColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: Text(
                                  'Chào mừng đăng ký ứng dụng \'viet_wallet\'',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Input(
                            hint: 'Tên đăng nhập',
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                            prefixIcon: Icons.person_outline,
                            onSubmit: (_) => focusNode.requestFocus(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập tên đăng nhập';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Input(
                            hint: 'Địa chỉ email',
                            controller: _emailController,
                            keyboardType: TextInputType.text,
                            prefixIcon: Icons.mail_outline,
                            onSubmit: (value) {
                              focusNode.requestFocus();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập địa chỉ email';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: InputPasswordField(
                            hint: 'Mật khẩu',
                            controller: _passwordController,
                            obscureText: !_isShowPassword,
                            onFieldSubmitted: (_) => focusNode.requestFocus(),
                            onTapSuffixIcon: () {
                              setState(() {
                                _isShowPassword = !_isShowPassword;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }
                              if (value.isNotEmpty && value.length < 6) {
                                return 'Mật khẩu phải có ít nhất 6 ký tự';
                              } else if (value.length > 40) {
                                return 'Mật khẩu không được quá 40 ký tự';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: InputPasswordField(
                            hint: 'Xác nhận mật khẩu',
                            controller: _confirmPasswordController,
                            obscureText: !_isShowConfirmPassword,
                            onFieldSubmitted: (_) => focusNode.requestFocus(),
                            onTapSuffixIcon: () {
                              setState(() {
                                _isShowConfirmPassword =
                                    !_isShowConfirmPassword;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập xác nhận mật khẩu';
                              }
                              if (value.isNotEmpty && value.length < 6) {
                                return 'Mật khẩu phải có ít nhất 6 ký tự';
                              } else if (value.length > 40) {
                                return 'Mật khẩu không được quá 40 ký tự';
                              } else if (value != _passwordController.text) {
                                return 'Mật khẩu và xác nhận mật khẩu phải giống nhau';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buttonSignUp(context, state)
              ],
            ),
          ),
          _goToSignInPage(),
        ],
      ),
    );
  }

  Widget _buttonSignUp(BuildContext context, SignUpState currentState) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: PrimaryButton(
        text: 'Đăng ký',
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            final connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult == ConnectivityResult.none) {
              showMessageNoInternetDialog(this.context);
            } else {
              _signUpBloc.add(SignUpLoading());
              final Map<String, dynamic> data = {
                "email": _emailController.text.trim(),
                // "fullName": "string",
                "password": _passwordController.text.trim(),
                // "phone": "string",
                // "roles": ["string"],
                "username": _usernameController.text.trim()
              };

              final response = await _authProvider.signUp(data: data);
              if (response.isOK()) {
                _signUpBloc.add(Validate());
                showSuccessBottomSheet(
                  this.context,
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
                _signUpBloc.add(Validate());
                showMessage1OptionDialog(
                  this.context,
                  response.errors?.first.errorMessage,
                );
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
            'Bạn đã có tài khoản? ',
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
              'Đăng nhập',
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
