import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_state.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_bloc.dart';
import 'package:viet_wallet/widgets/input_field.dart';
import 'package:viet_wallet/widgets/primary_button.dart';

import '../../../widgets/custom_check_box.dart';
import '../../../widgets/input_password_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final focusNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isShowPassword = false;
  bool _rememberInfo = false;

  SignInBloc? _signInBloc;

  @override
  void initState() {
    _signInBloc = BlocProvider.of<SignInBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _signInBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<SignInBloc, SignInState>(builder: (context, state) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: height - 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _appIcon(),
                      _signInForm(),
                    ],
                  ),
                ),
                _buttonSignIn(),
                // _goToSignUp(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _appIcon() => Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Image.asset(
              'images/logo_app.png',
              width: 150,
              height: 160,
              color: Theme.of(context).primaryColor,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Welcome',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
            )
          ],
        ),
      );

  Widget _signInForm() {
    return Container(
      height: 350,
      padding: const EdgeInsets.only(top: 32, left: 16.0, right: 16),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
            child: Input(
              textInputAction: TextInputAction.next,
              controller: _emailController,
              onChanged: (text) {},
              keyboardType: TextInputType.text,
              onSubmit: (_) => focusNode.requestFocus(),
              hint: 'Email',
              prefixIcon: const Icon(
                Icons.email_outlined,
                size: 24,
                color: Colors.grey,
              ),
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
                hint: 'Password',
                prefixIconPath: 'images/ic_lock.png',
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
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _rememberInfo = !_rememberInfo;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CustomCheckBox(
                            value: _rememberInfo,
                            onChanged: (value) {
                              setState(() {
                                _rememberInfo = value;
                              });
                            },
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Remember password',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.2,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ForgotPasswordPage(
                      //       phoneNumber: _inputPhoneController.text,
                      //     ),
                      //   ),
                      // );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
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

  Widget _buttonSignIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PrimaryButton(
          text: 'Sign In',
          onTap: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account? ',
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
                        child: SignUpPage(),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Register',
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
