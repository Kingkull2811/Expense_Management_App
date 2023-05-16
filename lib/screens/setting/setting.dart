import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:viet_wallet/screens/setting/category_item/category_item.dart';
import 'package:viet_wallet/screens/setting/category_item/category_item_bloc.dart';
import 'package:viet_wallet/screens/setting/security/security.dart';
import 'package:viet_wallet/utilities/screen_utilities.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';
import 'package:viet_wallet/utilities/utils.dart';

import 'limit_expenditure/limit.dart';
import 'limit_expenditure/limit_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isHiddenAmount = SharedPreferencesStorage().getHiddenAmount() ?? false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _featureOption(),
            _generalSettings(),
          ],
        ),
      ),
    );
  }

  Widget _generalSettings() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Cài đặt chung',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              _itemCurrencySetting(),
              _widgetHideAmount(),
              _itemOption(
                icon: Icons.lock_outline,
                title: 'Bảo mật',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecurityPage(),
                    ),
                  );
                },
              ),
              Divider(height: 0.5, color: Colors.grey.withOpacity(0.2)),
              _logout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureOption() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Tính năng',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            _itemOption(
                title: 'Hạn mức chi',
                imagePath: 'images/ic_spending_limit.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<LimitBloc>(
                        create: (context) => LimitBloc(context),
                        child: const LimitPage(),
                      ),
                    ),
                  );
                }),
            _itemOption(
              title: 'Hạng mục thu/chi',
              icon: Icons.list_alt_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<CategoryItemBloc>(
                      create: (context) => CategoryItemBloc(context),
                      child: const CategoryItem(),
                    ),
                  ),
                );
              },
            ),
            _itemOption(
              title: 'Ghi chép định kỳ',
              icon: Icons.edit_calendar_outlined,
            ),
            _itemOption(
              title: 'Xuất file excel',
              imagePath: 'images/ic_excel_file.png',
            ),
            _itemOption(
              title: 'Tra cứu tỷ giá',
              imagePath: 'images/ic_currency_search.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _logout() {
    return InkWell(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: AlertDialog(
                  title: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  content: const Text(
                    'Bạn có muón đăng xuất tài khoản này?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Huỷ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: TextButton(
                            onPressed: () {
                              logout(context);
                            },
                            child: const Text(
                              'Đăng xuất',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
      },
      child: SizedBox(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 16),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.logout,
                  size: 24,
                  color: Colors.red,
                ),
              ),
            ),
            const Expanded(
              child: Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.white,
      leading: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).backgroundColor,
              border: Border.all(
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 35,
              color: Colors.grey,
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            SharedPreferencesStorage().getUserName(),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            SharedPreferencesStorage().getUserEmail(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemOption({
    IconData? icon,
    String? title,
    String? imagePath,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Divider(height: 0.5, color: Colors.grey.withOpacity(0.2)),
          Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 16),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: isNotNullOrEmpty(icon)
                          ? Icon(
                              icon,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Image.asset(
                                imagePath ?? '',
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemCurrencySetting() {
    return InkWell(
      onTap: () {
        showCurrencyPicker(
            context: context,
            showFlag: true,
            showCurrencyName: true,
            showCurrencyCode: true,
            showSearchField: false,
            onSelect: (Currency value) async {
              await SharedPreferencesStorage()
                  .setCurrency(currency: '${value.symbol}(${value.code})');
              setState(() {});
            },
            favorite: ['VND']);
      },
      child: Column(
        children: [
          Divider(height: 0.5, color: Colors.grey.withOpacity(0.2)),
          Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 16),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          'images/ic_currency_setting.png',
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Thiết lập đơn vị tiền tệ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      SharedPreferencesStorage().getCurrency() ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetHideAmount() {
    return InkWell(
      onTap: () async {
        setState(() {
          _isHiddenAmount = !_isHiddenAmount;
        });
        await SharedPreferencesStorage().setHiddenAmount(_isHiddenAmount);
      },
      child: Column(
        children: [
          Divider(height: 0.5, color: Colors.grey.withOpacity(0.2)),
          Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 16),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Ẩn số tiền',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: FlutterSwitch(
                      activeColor: Theme.of(context).primaryColor,
                      width: 40,
                      height: 20,
                      valueFontSize: 25.0,
                      toggleSize: 18,
                      value: _isHiddenAmount,
                      borderRadius: 10,
                      padding: 2,
                      showOnOff: false,
                      onToggle: (val) {
                        setState(() {
                          _isHiddenAmount = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
