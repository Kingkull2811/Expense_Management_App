import 'package:dio/dio.dart';

class AppConstants{
  static const String rememberInfo = 'REMEMBER_INFO';
  static const String isLoggedOut = 'IS_LOGGED_OUT';
  static const String passwordExpireTimeKey = 'PASSWORD_EXPIRE_TIME';
  static const String refreshTokenKey = 'REFRESH_TOKEN';
  static const String accessTokenKey = 'ACCESS_TOKEN';
  static const String authTokenExpireKey = 'AUTH_TOKEN_EXPIRE_TIME';
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


  static const String noInternetTitle = 'No Internet Connection';
  static const String noInternetContent = 'Please check your internet connection again or connect to Wi-fi';

}