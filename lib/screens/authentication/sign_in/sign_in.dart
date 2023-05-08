import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/network/provider/auth_provider.dart';
import 'package:viet_wallet/network/response/sign_in_response.dart';
import 'package:viet_wallet/network/response/user_response.dart';
import 'package:viet_wallet/routes.dart';
import 'package:viet_wallet/screens/authentication/forgot_password/forgot_password.dart';
import 'package:viet_wallet/screens/authentication/forgot_password/forgot_password_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_event.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_state.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_bloc.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';
import 'package:viet_wallet/utilities/screen_utilities.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';
import 'package:viet_wallet/widgets/input_field.dart';
import 'package:viet_wallet/widgets/primary_button.dart';

import '../../../widgets/input_password_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final focusNode = FocusNode();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isShowPassword = false;

  late SignInBloc _signInBloc;
  final _authProvider = AuthProvider();

  @override
  void initState() {
    _signInBloc = BlocProvider.of<SignInBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _signInBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, curState) {
        if (curState.apiError == ApiError.internalServerError) {
          showMessage1OptionDialog(context, 'Error!',
              content: 'Internal_server_error');
        }
        if (curState.apiError == ApiError.noInternetConnection) {
          showMessageNoInternetDialog(context);
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

  Widget _body(SignInState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height - 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _appIcon(),
                  _signInForm(),
                ],
              ),
            ),
            _buttonSignIn(state),
            // _goToSignUp(),
          ],
        ),
      ),
    );
  }

  Widget _appIcon() => Padding(
        padding: const EdgeInsets.only(top: 80, bottom: 20),
        child: Column(
          children: [
            Image.asset(
              'images/logo_app.png',
              width: 150,
              height: 160,
              color: Theme.of(context).primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Chào mừng trở lại!\nVui lòng đăng nhập.',
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
      );

  Widget _signInForm() {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(top: 30, left: 16.0, right: 16),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
            child: Input(
              textInputAction: TextInputAction.next,
              controller: _usernameController,
              onChanged: (text) {},
              keyboardType: TextInputType.text,
              onSubmit: (_) => focusNode.requestFocus(),
              hint: 'Tên đăng nhập',
              prefixIcon: Icons.email_outlined,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: SizedBox(
              height: 50,
              child: InputPasswordField(
                controller: _passwordController,
                onChanged: (text) {},
                keyboardType: TextInputType.text,
                onFieldSubmitted: (_) => focusNode.requestFocus(),
                hint: 'Mật khẩu',
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
            padding: const EdgeInsets.only(top: 20.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => ForgotPasswordBloc(context),
                            child: const ForgotPasswordPage(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Quên mật khẩu?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonSignIn(SignInState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PrimaryButton(
          text: 'Đăng nhập',
          onTap: () async {
            ConnectivityResult connectivityResult =
                await Connectivity().checkConnectivity();
            if (connectivityResult == ConnectivityResult.none && mounted) {
              showMessageNoInternetDialog(context);
            } else {
              _signInBloc.add(DisplayLoading());

              SignInResponse signInResponse = await _authProvider.signIn(
                username: _usernameController.text.trim(),
                password: _passwordController.text.trim(),
              );
              if (signInResponse.httpStatus == 200) {
                await SharedPreferencesStorage().setLoggedOutStatus(false);
                await _saveUserInfo(signInResponse.data);
                if (mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                }
              } else {
                _signInBloc.add(SignInFailure(
                  errorMessage: signInResponse.errors?.first.errorMessage,
                ));
                if (mounted) {
                  showMessage1OptionDialog(
                    context,
                    signInResponse.errors?.first.errorMessage,
                    content: 'Vui lòng nhập lại',
                    buttonLabel: 'OK',
                  );
                }
              }
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bạn chưa có tài khoản? ',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<SignUpBloc>(
                        create: (context) => SignUpBloc(context),
                        child: const SignUpPage(),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Đăng ký',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> _saveUserInfo(UserResponse? signInData) async {
  await SharedPreferencesStorage().setSaveUserInfo(signInData);
}
