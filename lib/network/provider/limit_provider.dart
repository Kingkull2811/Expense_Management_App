import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';
import 'package:viet_wallet/network/response/get_list_wallet_response.dart';
import 'package:viet_wallet/network/response/list_limit_response.dart';

import '../api/api_path.dart';
import '../model/limit_post_data.dart';
import '../response/base_get_response.dart';

class LimitProvider with ProviderMixin {
  Future<BaseGetResponse> getListLimit() async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }

    try {
      final response = await dio.get(
        ApiPath.expenseLimit,
        options: await defaultOptions(url: ApiPath.expenseLimit),
      );
      log('response: ${jsonDecode(response.toString())}');

      return ListLimitResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.expenseLimit);
    }
  }

  Future<Object> addLimit({
    required Object data,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      Options options = await defaultOptions(
        url: ApiPath.expenseLimit,
      );

      final response = await dio.post(
        ApiPath.expenseLimit,
        data: data,
        options: options,
      );

      return LimitData.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.getListWallet);
    }
  }

  Future<BaseGetResponse> updateNewWallet({
    required int? walletId,
    required Object data,
  }) async {
    String apiUpdateWallet = '${ApiPath.getListWallet}/$walletId';
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      Options options = await defaultOptions(url: apiUpdateWallet);

      final response = await dio.put(
        apiUpdateWallet,
        data: data,
        options: options,
      );

      return GetListWalletResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, apiUpdateWallet);
    }
  }

  Future<Object> removeWalletWithId({
    required int walletId,
  }) async {
    String apiRemoveWallet = '${ApiPath.getListWallet}/$walletId';

    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      Options options = await defaultOptions(url: apiRemoveWallet);

      return await dio.delete(apiRemoveWallet, options: options);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, apiRemoveWallet);
    }
  }
}
