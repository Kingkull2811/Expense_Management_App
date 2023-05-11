import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:viet_wallet/utilities/screen_utilities.dart';

import '../../../network/provider/auth_provider.dart';
import '../../../widgets/input_password_field.dart';
import '../../../widgets/primary_button.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _authProvider = AuthProvider();

  final _oldPassCon = TextEditingController();
  final _newPassCon = TextEditingController();
  final _confirmNewPassCon = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:
                const Icon(Icons.arrow_back_ios, size: 24, color: Colors.white),
          ),
          centerTitle: true,
          title: const Text(
            'Đổi mật khẩu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: InputPasswordField(
                    controller: _oldPassCon,
                    hint: 'Mật khẩu cũ',
                    onChanged: (_) {},
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    obscureText: !_showOld,
                    prefixIcon: Icons.lock_outline,
                    onTapSuffixIcon: () {
                      setState(() {
                        _showOld = !_showOld;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: InputPasswordField(
                    controller: _newPassCon,
                    hint: 'Mật khẩu mới',
                    onChanged: (_) {},
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    obscureText: !_showNew,
                    prefixIcon: Icons.lock_outline,
                    onTapSuffixIcon: () {
                      setState(() {
                        _showNew = !_showNew;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: InputPasswordField(
                    controller: _confirmNewPassCon,
                    hint: 'Xác nhận mật khẩu mới',
                    onChanged: (_) {},
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    obscureText: !_showConfirm,
                    prefixIcon: Icons.lock_outline,
                    onTapSuffixIcon: () {
                      setState(() {
                        _showConfirm = !_showConfirm;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 16),
                  child: PrimaryButton(
                    text: 'Đổi mật khẩu',
                    onTap: () async {
                      if (_oldPassCon.text.isEmpty) {
                        showMessage1OptionDialog(
                          context,
                          'Mật khẩu cũ không được trống',
                        );
                      } else if (_newPassCon.text.isEmpty) {
                        showMessage1OptionDialog(
                          context,
                          'Mật khẩu mới không được trống',
                        );
                      } else if (_confirmNewPassCon.text.isEmpty) {
                        showMessage1OptionDialog(
                          context,
                          'Xác nhận mật khẩu mới không được trống',
                        );
                      } else if (_newPassCon.text != _newPassCon.text) {
                        showMessage1OptionDialog(
                          context,
                          'Mật khẩu mới và xác nhận mật khẩu mới không khớp',
                        );
                      } else {
                        final connectivityResult =
                            await Connectivity().checkConnectivity();
                        if (connectivityResult == ConnectivityResult.none &&
                            mounted) {
                          showMessageNoInternetDialog(context);
                        } else {
                          final response = await _authProvider.changePassword(
                            oldPass: _oldPassCon.text.trim(),
                            newPass: _newPassCon.text.trim(),
                            confPass: _confirmNewPassCon.text.trim(),
                          );
                          if (response.isOK()) {
                            showMessage1OptionDialog(
                              this.context,
                              'Đổi mật khẩu thành công',
                              onClose: () {
                                setState(() {
                                  _oldPassCon.clear();
                                  _newPassCon.clear();
                                  _confirmNewPassCon.clear();
                                });
                              },
                            );
                          } else {
                            showMessage1OptionDialog(
                              this.context,
                              'Error!',
                              content: response.errors?.first.errorMessage,
                            );
                          }
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
