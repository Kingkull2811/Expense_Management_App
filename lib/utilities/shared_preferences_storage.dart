import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viet_wallet/network/model/sign_in_data.dart';
import 'package:viet_wallet/utilities/app_constants.dart';
import 'package:viet_wallet/utilities/secure_storage.dart';

class SharedPreferencesStorage {
  static late SharedPreferences _preferences;

  static Future<void> init() async{
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setSaveUserInfo(SignInData? signInData) async {
    if(signInData != null){
      var token = signInData.accessToken?.split(' ')[1];

      final SecureStorage secureStorage = SecureStorage();
      //write accessToken, refreshToken to secureStorage
      await secureStorage.writeSecureData(AppConstants.accessTokenKey, token);
      await secureStorage.writeSecureData(
          AppConstants.refreshTokenKey, signInData.refreshToken);
      await _preferences.setString(
          AppConstants.emailKey, signInData.email.toString());
      await _preferences.setString(
          AppConstants.usernameKey, signInData.username.toString());

      //Decode token and get expiration time
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        bool hasExpired = JwtDecoder.isExpired(token);
        DateTime expirationDate = JwtDecoder.getExpirationDate(token);
      }
    }
  }
}