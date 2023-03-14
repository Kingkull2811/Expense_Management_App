import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in.dart';
import 'package:viet_wallet/screens/authentication/sign_in/sign_in_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_bloc.dart';
import 'package:viet_wallet/screens/authentication/sign_up/sign_up_state.dart';
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
  bool _isErrorConfirmPassword = false;
  String? errorMessage;

  SignUpBloc? _signUpBloc;

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
    _signUpBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _registerForm(padding, height),
            _goToSignInPage(),
          ],
        ),
      ),
    );
  }

  Widget _registerForm(EdgeInsets padding, double height) {
    return BlocConsumer<SignUpBloc, SignUpState>(
        // listenWhen: (previousState, currentState){
        //   //return currentState;
        // },
        listener: (context, currentState) {
      return;
    }, builder: (context, currentState) {
      return Padding(
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
                  iconLeading: const Icon(
                    Icons.person,
                    color: Colors.grey, //Color.fromARGB(102, 230, 230, 230),
                    size: 24,
                  ),
                ),
                _inputTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  iconLeading: const Icon(
                    Icons.mail_outline,
                    color: Colors.grey, // Color.fromARGB(102, 230, 230, 230),
                    size: 24,
                  ),
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
                  validator: (text){
                    if()
                  },
                ),
              ]),
            ),
            _buttonSendOTP(
              currentState,
              _usernameController.text,
            )
          ],
        ),
      );
    });
  }

  Widget _inputTextField({
    required String hintText,
    required TextEditingController controller,
    required TextInputType keyboardType,
    Icon? iconLeading,
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
          prefixIconPath: prefixIconPath,
          prefixIcon: iconLeading,
        ),
      ),
    );
  }

  Widget _passwordField({
    String? hintText,
    Function? onTapSuffixIcon,
    required TextEditingController controller,
    bool obscureText =false,
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
          prefixIcon: const Icon(
            Icons.lock_outline,
            size: 24,
            color: Colors.grey,
          ),
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
            //todo: send otp to phone number
            // _registerBloc?.add(DisplayLoading());
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
                    child: SignInScreen(),
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

// _validateForm(){
//   _registerBloc?.add(ValidateForm(isValidate: (_inputPhoneController.text.isNotEmpty
//       && _inputFirstNameController.text.isNotEmpty
//       && _inputLastNameController.text.isNotEmpty)));
// }
}
