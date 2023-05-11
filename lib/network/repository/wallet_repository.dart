import 'package:viet_wallet/network/provider/wallet_provider.dart';
import 'package:viet_wallet/network/response/base_get_response.dart';

class WalletRepository {
  final WalletProvider _walletProvider = WalletProvider();

  Future<BaseGetResponse> getListWallet() => _walletProvider.getListWallet();

  Future<BaseGetResponse> createNewWallet({
    required int accountBalance,
    required String accountType,
    required String currency,
    required String description,
    required String name,
    required bool report,
  }) {
    final data = {
      "accountBalance": accountBalance,
      "accountType": accountType,
      "currency": currency,
      "description": description,
      "name": name,
      "report": report
    };

    return _walletProvider.createNewWallet(data: data);
  }

  Future<BaseGetResponse> updateNewWallet({
    required int? walletId,
    required int accountBalance,
    required String accountType,
    required String currency,
    required String description,
    required String name,
    required bool report,
  }) {
    final data = {
      "accountBalance": accountBalance,
      "accountType": accountType,
      "currency": currency,
      "description": description,
      "name": name,
      "report": report
    };

    return _walletProvider.updateNewWallet(walletId: walletId, data: data);
  }

  Future<Object> removeWalletWithID({required int walletId}) =>
      _walletProvider.removeWalletWithId(walletId: walletId);
}
