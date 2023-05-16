import 'package:dio/dio.dart';
import 'package:viet_wallet/network/api/api_path.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';
import 'package:viet_wallet/network/response/auth_response.dart';
import 'package:viet_wallet/network/response/base_response.dart';
import 'package:viet_wallet/network/response/forgot_password_response.dart';
import 'package:viet_wallet/network/response/sign_in_response.dart';
import 'package:viet_wallet/network/response/sign_up_response.dart';
import 'package:viet_wallet/network/response/verify_otp_response.dart';
import 'package:viet_wallet/utilities/app_constants.dart';
import 'package:viet_wallet/utilities/secure_storage.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';

class AuthProvider with ProviderMixin {
  final SecureStorage _secureStorage = SecureStorage();

  Future<bool> checkAuthenticationStatus() async {
    String accessTokenExpired =
        SharedPreferencesStorage().getAccessTokenExpired();

    if (DateTime.parse(accessTokenExpired).isBefore(DateTime.now())) {
      String refreshTokenExpired =
          SharedPreferencesStorage().getRefreshTokenExpired();

      if (DateTime.parse(refreshTokenExpired).isAfter(DateTime.now())) {
        String refreshToken = await _secureStorage.readSecureData(
          AppConstants.refreshTokenKey,
        );

        final response = await AuthProvider().refreshToken(
          refreshToken: refreshToken,
        );
        await SharedPreferencesStorage().saveUserInfoRefresh(
          refreshTokenData: response,
        );
        return true;
      }
      return false;
    }
    return true;
  }

  Future<SignUpResponse> signUp({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post(
        ApiPath.signup,
        data: data,
        // options: AppConstants.options,
      );

      return SignUpResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.signup);
      if (error is DioError) {
        return SignUpResponse.fromJson(error.response?.data);
      }
      return SignUpResponse();
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
      return SignInResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.signIn);
      if (error is DioError) {
        return SignInResponse.fromJson(error.response?.data);
      }
      return SignInResponse();
    }
  }

  Future<AuthResponse> refreshToken({
    required String refreshToken,
  }) async {
    try {
      Response response = await dio.post(
        ApiPath.refreshToken,
        data: {"refreshToken": refreshToken},
        // options: AppConstants.options,
      );

      // log("new token data: ${response.data.toString()}");

      return AuthResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.refreshToken);
      return AuthResponse();
    }
  }

  Future<ForgotPasswordResponse> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await dio.post(
        ApiPath.forgotPassword,
        data: {"email": email},
      );
      return ForgotPasswordResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return ForgotPasswordResponse.fromJson(error.response?.data);
      }
      return ForgotPasswordResponse();
    }
  }

  Future<VerifyOtpResponse> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      final data = {"email": email, "otp": otpCode};

      final response = await dio.post(
        ApiPath.sendOtp,
        data: data,
        //options: AppConstants.options,
      );
      return VerifyOtpResponse.fromJson(response.data);
    } catch (error) {
      //showErrorLog(error, stacktrace, ApiPath.sendOtp);
      if (error is DioError) {
        return VerifyOtpResponse.fromJson(error.response?.data);
      }
      return VerifyOtpResponse();
    }
  }

  Future<BaseResponse> newPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final data = {
        "confirm_password": confirmPassword,
        "email": email,
        "password": confirmPassword
      };

      final response = await dio.post(
        ApiPath.newPassword,
        data: data,
        //options: AppConstants.options,
      );
      // log(response.toString());
      return BaseResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.newPassword);
      return BaseResponse();
    }
  }

  Future<BaseResponse> changePassword({
    required String oldPass,
    required String newPass,
    required String confPass,
  }) async {
    final data = {
      "confirm_password": confPass,
      "current_password": oldPass,
      "password": newPass
    };
    if (await isExpiredToken()) {
      return ExpiredTokenResponse();
    }
    try {
      final response = await dio.post(
        ApiPath.changePassword,
        data: data,
        options: await defaultOptions(url: ApiPath.changePassword),
      );
      // log(response.toString());
      return BaseResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      showErrorLog(error, stacktrace, ApiPath.changePassword);
      return BaseResponse();
    }
  }
}
