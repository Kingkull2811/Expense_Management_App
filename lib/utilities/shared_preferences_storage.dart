import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viet_wallet/network/response/user_response.dart';
import 'package:viet_wallet/network/response/auth_response.dart';
import 'package:viet_wallet/utilities/app_constants.dart';
import 'package:viet_wallet/utilities/secure_storage.dart';

class SharedPreferencesStorage {
  static late SharedPreferences _preferences;
  final SecureStorage _secureStorage = SecureStorage();

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///save user info
  Future<void> setSaveUserInfo(UserResponse? signInData) async {
    if (signInData != null) {
      var token = signInData.accessToken?.split(' ')[1];
      await _secureStorage.writeSecureData(AppConstants.accessTokenKey, token);
      await _secureStorage.writeSecureData(
          AppConstants.refreshTokenKey, signInData.refreshToken);
      await _secureStorage.writeSecureData(
          AppConstants.emailKey, signInData.email.toString());

      if (signInData.expiredAccessToken != null) {
        await _preferences.setString(
            AppConstants.accessTokenExpiredKey, signInData.expiredAccessToken!);
      }

      if (signInData.expiredRefreshToken != null) {
        await _preferences.setString(AppConstants.refreshTokenExpiredKey,
            signInData.expiredRefreshToken!);
      }

      if (signInData.username != null) {
        await _preferences.setString(
            AppConstants.usernameKey, signInData.username!);
      }
    }
  }

  Future<void> saveUserInfoRefresh({
    required AuthResponse refreshTokenData,
  }) async {
    var token = refreshTokenData.accessToken?.split(' ')[1];

    //write accessToken, refreshToken to secureStorage
    await _secureStorage.writeSecureData(AppConstants.accessTokenKey, token);
    await _secureStorage.writeSecureData(
      AppConstants.refreshTokenKey,
      refreshTokenData.refreshToken,
    );
  }

  Future<String> getAccessToken() async {
    final token = await _secureStorage.readSecureData(
      AppConstants.accessTokenKey,
    );
    return token;
  }

  String? getAccessTokenExpired() {
    return _preferences.getString(AppConstants.accessTokenExpiredKey);
  }

  String? getRefreshTokenExpired() {
    return _preferences.getString(AppConstants.refreshTokenExpiredKey);
  }
}
