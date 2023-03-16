import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:viet_wallet/network/api/api_path.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';
import 'package:viet_wallet/network/response/auth_response.dart';
import 'package:viet_wallet/network/response/base_response.dart';
import 'package:viet_wallet/network/response/forgot_password_response.dart';
import 'package:viet_wallet/network/response/sign_in_response.dart';
import 'package:viet_wallet/utilities/app_constants.dart';
import 'package:viet_wallet/utilities/secure_storage.dart';

class AuthProvider with ProviderMixin {
  final SecureStorage secureStorage = SecureStorage();

  Future<BaseResponse> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final data = {
        "email": email,
        "password": password,
        "username": username,
      };

      final response = await dio.post(
        ApiPath.signup,
        data: data,
        options: AppConstants.options,
      );

      return BaseResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.signup);
      if (error is DioError) {
        return BaseResponse.fromJson(error.response?.data);
      }
      return BaseResponse();
    }
  }

  Future<SignInResponse> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final data = {
        "password": password,
        "username": username,
      };

      final response = await dio.post(
        ApiPath.signIn,
        data: data,
        options: AppConstants.options,
      );
      log('provider: ${response.toString()}');
      return SignInResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.signIn);
      // if (error is DioError) {
      //   return SignInResponse.fromJson(error.response?.data);
      // }
      return SignInResponse();
    }
  }

  Future<AuthResponse> refreshToken() async {
    try {
      final data = {
        "refreshToken": (await secureStorage.readSecureData(
          AppConstants.refreshTokenKey,
        ))
      };
      final response = await dio.post(
        ApiPath.refreshToken,
        data: data,
        options: AppConstants.options,
      );

      log("token data: ${response.data.toString()}");

      return AuthResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.refreshToken);
      return AuthResponse();
    }
  }

  Future<ForgotPasswordResponse> forgotPassword({
    required String email,
  }) async {
    try{
      final response = await dio.post(
        ApiPath.forgotPassword,
        data: {"email": email},
        options: AppConstants.options,
      );

      return ForgotPasswordResponse.fromJson(response.data);
    }
    catch(error, stacktrace){
      showErrorLog(error, stacktrace, ApiPath.forgotPassword);
      return ForgotPasswordResponse();
    }
  }

  Future<BaseResponse> verifyOtp({
    required String email,
    required String otpCode,
})async{
    try{
      final data = {"email": email, "otp": otpCode};

      final response = await dio.post(ApiPath.sendOtp, data: data, options: AppConstants.options,);
      return BaseResponse.fromJson(response.data);
    }catch(error, stacktrace){
      showErrorLog(error, stacktrace, ApiPath.sendOtp);
      return BaseResponse();
    }

  }
}
