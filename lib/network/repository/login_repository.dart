import '../../utilities/shared_preferences_storage.dart';
import '../model/login_result.dart';
import '../provider/login_provider.dart';

class LoginRepository {
  LoginProvider _loginProvider = LoginProvider();

  Future<void> _saveUserInfo()async{
    await SharedPreferencesStorage().setSaveUserInfo();
}

  Future<LoginResult> login({
    required String phone,
    required String password,
  }) async {

    return LoginResult();
  }
}
