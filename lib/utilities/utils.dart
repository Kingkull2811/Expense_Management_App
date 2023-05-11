import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viet_wallet/utilities/enum/wallet_type.dart';

bool isNotNullOrEmpty(dynamic obj) => !isNullOrEmpty(obj);

/// For String, List, Map
bool isNullOrEmpty(dynamic obj) =>
    obj == null ||
    ((obj is String || obj is List || obj is Map) && obj.isEmpty);

String formatterDouble(double value) {
  final formatter = NumberFormat("#,##0.00", "en_US");
  return formatter.format(value);
}

String formatterInt(int? value) {
  if (value == null) {
    return '0';
  }
  final formatter = NumberFormat("#,##0.00", "en_US");
  return formatter.format(value);
}

String formatterBalance(String str) {
  var result = NumberFormat.compact(locale: 'en').format(int.parse(str));
  if (result.contains('K') && result.length > 3) {
    result = result.substring(0, result.length - 1);
    var prefix = (result.split('.').last.length) + 1;
    var temp = (double.parse(result) * .001).toStringAsFixed(prefix);
    result = '${double.parse(temp)}M';
  }
  return result;
}

IconData getIconWallet({String? walletType}) {
  if (walletType == null) {
    return Icons.help_outline;
  }
  if (walletType == WalletAccountType.wallet.name) {
    return Icons.wallet;
  }
  if (walletType == WalletAccountType.bank.name) {
    return Icons.account_balance;
  }
  if (walletType == WalletAccountType.eWallet.name) {
    return Icons.local_atm;
  }
  return Icons.payment;
}

String getNameWalletType({String? walletType}) {
  if (walletType == WalletAccountType.wallet.name) {
    return 'Ví tiền mặt';
  }
  if (walletType == WalletAccountType.bank.name) {
    return 'Tài khoản ngân hàng';
  }
  if (walletType == WalletAccountType.eWallet.name) {
    return "Ví điện tử";
  }
  return "Khác";
}

String formatToLocaleVietnam(DateTime date) {
  return '${DateFormat.EEEE('vi').format(date)} - ${DateFormat('dd/MM/yyyy').format(date)}';
}
