import 'package:shared_preferences/shared_preferences.dart';
import 'package:viet_wallet/network/response/auth_response.dart';
import 'package:viet_wallet/network/response/user_response.dart';
import 'package:viet_wallet/screens/new_collection/new_collection.dart';
import 'package:viet_wallet/utilities/app_constants.dart';
import 'package:viet_wallet/utilities/secure_storage.dart';

class SharedPreferencesStorage {
  static late SharedPreferences _preferences;
  final SecureStorage _secureStorage = SecureStorage();

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> setLoggedOutStatus(bool value) {
    return _preferences.setBool(AppConstants.isLoggedOut, value);
  }

  bool getLoggedOutStatus() {
    return _preferences.getBool(AppConstants.isLoggedOut) ?? true;
  }

  ///save user info
  Future<void> setSaveUserInfo(UserResponse? signInData) async {
    if (signInData != null) {
      // var token = signInData.accessToken?.split(' ')[1];
      await _secureStorage.writeSecureData(
          AppConstants.accessTokenKey, signInData.accessToken);
      await _secureStorage.writeSecureData(
          AppConstants.refreshTokenKey, signInData.refreshToken);

      if (signInData.expiredAccessToken != null) {
        await _preferences.setString(AppConstants.accessTokenExpiredTimeKey,
            signInData.expiredAccessToken!);
      }

      if (signInData.expiredRefreshToken != null) {
        await _preferences.setString(AppConstants.refreshTokenExpiredKey,
            signInData.expiredRefreshToken!);
      }

      if (signInData.username != null) {
        await _preferences.setString(
            AppConstants.usernameKey, signInData.username!);
      }
      if (signInData.email != null) {
        await _preferences.setString(AppConstants.emailKey, signInData.email!);
      }
    }
  }

  Future<void> setCurrency({required String currency}) async {
    await _preferences.setString(AppConstants.currencyKey, currency);
  }

  String? getCurrency() => _preferences.getString(AppConstants.currencyKey);

  Future<void> setHiddenAmount(bool value) async {
    await _preferences.setBool(AppConstants.isHiddenAmount, value);
  }

  bool? getHiddenAmount() => _preferences.getBool(AppConstants.isHiddenAmount);

  String getUserName() =>
      _preferences.getString(AppConstants.usernameKey) ?? '';

  String getUserEmail() => _preferences.getString(AppConstants.emailKey) ?? '';

  Future<void> saveUserInfoRefresh({
    required AuthResponse refreshTokenData,
  }) async {
    //write accessToken, refreshToken to secureStorage
    await _secureStorage.writeSecureData(
        AppConstants.accessTokenKey, refreshTokenData.accessToken);
    await _secureStorage.writeSecureData(
        AppConstants.refreshTokenKey, refreshTokenData.refreshToken);
    await _preferences.setString(AppConstants.accessTokenExpiredTimeKey,
        refreshTokenData.expiredAccessToken ?? '');
  }

  Future<String> getAccessToken() async {
    final token = await _secureStorage.readSecureData(
      AppConstants.accessTokenKey,
    );
    return token;
  }

  String getAccessTokenExpired() {
    return _preferences.getString(AppConstants.accessTokenExpiredTimeKey) ?? '';
  }

  String getRefreshTokenExpired() {
    return _preferences.getString(AppConstants.refreshTokenExpiredKey) ?? '';
  }

  void resetDataWhenLogout() {
    _preferences.remove(AppConstants.accessTokenExpiredTimeKey);
    _preferences.remove(AppConstants.refreshTokenExpiredKey);
    _preferences.remove(AppConstants.usernameKey);
    _preferences.setBool(AppConstants.isLoggedOut, false);
    _preferences.setBool(AppConstants.isRememberInfo, false);

    _secureStorage.deleteSecureData(AppConstants.emailKey);
    _secureStorage.deleteSecureData(AppConstants.accessTokenKey);
    _secureStorage.deleteSecureData(AppConstants.refreshTokenKey);
  }

  ///item category selected
  Future<void> setItemCategorySelected({
    int? categoryId,
    String? leading,
    String? title,
  }) async {
    await _preferences.setInt(AppConstants.itemId, categoryId ?? 0);
    await _preferences.setString(AppConstants.itemLeading, leading ?? '');
    await _preferences.setString(AppConstants.itemTitle, title ?? '');
  }

  ItemCategory getItemCategorySelected() {
    return ItemCategory(
        categoryId: _preferences.getInt(AppConstants.itemId),
        iconLeading: _preferences.getString(AppConstants.itemLeading) ?? '',
        title: _preferences.getString(AppConstants.itemTitle) ?? '');
  }

  Future<void> removeItemCategorySelected() async {
    await _preferences.remove(AppConstants.itemId);
    await _preferences.remove(AppConstants.itemLeading);
    await _preferences.remove(AppConstants.itemTitle);
  }
}
