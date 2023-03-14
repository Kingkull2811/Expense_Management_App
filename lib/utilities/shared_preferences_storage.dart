import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage {
  static SharedPreferences? _preferences;

  static Future<void> init() async{
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setSaveUserInfo()async{

  }
}