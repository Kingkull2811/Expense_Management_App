import 'package:viet_wallet/network/model/base_result.dart';
import 'package:viet_wallet/network/model/sign_in_result.dart';
import 'package:viet_wallet/network/provider/auth_provider.dart';
import 'package:viet_wallet/network/response/base_response.dart';
import 'package:viet_wallet/network/response/sign_in_response.dart';
import 'package:viet_wallet/network/response/user_response.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';

class AuthRepository {
  final _authProvider = AuthProvider();

  Future<void> _saveUserInfo(UserResponse? signInData) async {
    await SharedPreferencesStorage().setSaveUserInfo(signInData);
  }

  Future<SignInResult> signIn({
    required String username,
    required String password,
  }) async {
    SignInResponse signInResponse = await _authProvider.signIn(
      username: username,
      password: password,
    );
    if (signInResponse.httpStatus == 200) {
      _saveUserInfo(signInResponse.data);
      return SignInResult(
        isSuccess: true,
      );
    }

    return SignInResult(
        isSuccess: false, error: LoginError.internalServerError);
  }

  Future<BaseResult> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    BaseResponse signUpResponse = await _authProvider.signUp(
      email: email,
      username: username,
      password: password,
    );

    // log('signUp: ${signUpResponse.toString()}');

    if (signUpResponse.httpStatus == 200) {
      return BaseResult(
        isSuccess: true,
        message: signUpResponse.message,
        errors: null,
      );
    }

    return BaseResult(
      isSuccess: false,
      message: null,
      errors: signUpResponse.errors,
    );
  }

  // Future<void> refreshToken() async {
  //   final refreshToken = await
  //   final response = await _authProvider.refreshToken(refreshToken: '');
  //   await SharedPreferencesStorage().saveUserInfoRefresh(refreshTokenData: response.,
  //   );
  // }
}
