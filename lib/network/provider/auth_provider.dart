import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:viet_wallet/network/api/api_path.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';
import 'package:viet_wallet/network/response/base_response.dart';
import 'package:viet_wallet/network/response/sign_in_response.dart';
import 'package:viet_wallet/utilities/app_constants.dart';

class AuthProvider with ProviderMixin {
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
}
