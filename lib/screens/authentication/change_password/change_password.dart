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

  final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: InputPasswordField(
                      controller: _oldPassCon,
                      hint: 'Mật khẩu cũ',
                      onChanged: (_) {},
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      obscureText: !_showOld,
                      onTapSuffixIcon: () {
                        setState(() {
                          _showOld = !_showOld;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu cũ';
                        }
                        if (value.isNotEmpty && value.length < 6) {
                          return 'Mật khẩu phải có ít nhất 6 ký tự';
                        } else if (value.length > 40) {
                          return 'Mật khẩu không được quá 40 ký tự';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: InputPasswordField(
                      controller: _newPassCon,
                      hint: 'Mật khẩu mới',
                      onChanged: (_) {},
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      obscureText: !_showNew,
                      onTapSuffixIcon: () {
                        setState(() {
                          _showNew = !_showNew;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu mới';
                        }
                        if (value.isNotEmpty && value.length < 6) {
                          return 'Mật khẩu phải có ít nhất 6 ký tự';
                        } else if (value.length > 40) {
                          return 'Mật khẩu không được quá 40 ký tự';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: InputPasswordField(
                      controller: _confirmNewPassCon,
                      hint: 'Xác nhận mật khẩu mới',
                      onChanged: (_) {},
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      obscureText: !_showConfirm,
                      onTapSuffixIcon: () {
                        setState(() {
                          _showConfirm = !_showConfirm;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập xác nhận mật khẩu mới';
                        }
                        if (value.isNotEmpty && value.length < 6) {
                          return 'Mật khẩu phải có ít nhất 6 ký tự';
                        } else if (value.length > 40) {
                          return 'Mật khẩu không được quá 40 ký tự';
                        } else if (value != _newPassCon.text) {
                          return 'Mật khẩu và xác nhận mật khẩu phải giống nhau';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 16),
                    child: PrimaryButton(
                      text: 'Đổi mật khẩu',
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          final connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult == ConnectivityResult.none &&
                              mounted) {
                            showMessageNoInternetDialog(context);
                          } else {
                            showLoading(context);
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
      ),
    );
  }
}
