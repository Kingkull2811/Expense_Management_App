import 'package:dio/dio.dart';

class AppConstants{
  static const String isRememberInfo = 'REMEMBER_INFO';
  static const String isLoggedOut = 'IS_LOGGED_OUT';
  static const String passwordExpireTimeKey = 'PASSWORD_EXPIRE_TIME';
  static const String refreshTokenKey = 'REFRESH_TOKEN';
  static const String refreshTokenExpiredKey = 'REFRESH_TOKEN_EXPIRED';
  static const String accessTokenKey = 'ACCESS_TOKEN';
  static const String accessTokenExpiredKey = 'ACCESS_TOKEN_EXPIRED';
  static const String usernameKey = 'USERNAME';
  static const String emailKey = 'EMAIL';

  static const String firstTimeOpenKey = 'FIRST_TIME_OPEN';
  static const String agreedWithTermsKey = 'AGREED_WITH_TERMS';


  //for set options timeOut waiting request dio connect to servers
  static Options options = Options(
    sendTimeout: const Duration(seconds: 3),
    receiveTimeout: const Duration(seconds: 3),
    receiveDataWhenStatusError: true,
  );
  static RegExp emailExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  static RegExp  passwordExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');

  // ignore: constant_identifier_names
  static const String set_new_password_success =  'Thiết lập mật khẩu mới thành công.\nVui lòng đăng nhập lại với mật khẩu mới.';

  static const String forgotPassword ='If you don\'t remember your password.\nEnter your email below, we will send a code to your email for reset your password.';
  static const String noInternetTitle = 'No Internet Connection';
  static const String noInternetContent = 'Please check your internet connection again or connect to Wi-fi';

}