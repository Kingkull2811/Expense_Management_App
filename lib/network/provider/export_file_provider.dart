import 'dart:developer';

import 'package:viet_wallet/network/api/api_path.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';
import 'package:viet_wallet/network/response/base_get_response.dart';

class ExportProvider with ProviderMixin {
  Future<Object> getFileReport(
    Map<String, dynamic> queryParameters,
    List<int> walletIDs,
  ) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    // try {
    // String savePath = 'storage/emulated/0/Download/viet-wallet/';

    final response = await dio.put(
      ApiPath.exportData,
      // savePath,
      data: {'walletIds': walletIDs.toString()},
      queryParameters: queryParameters,
      options: await defaultOptions(url: ApiPath.exportData),
    );

    log('query: $queryParameters, listint: ${walletIDs.toString()}');
    log('response: ${response.toString()}');

    return response;
    // } catch (error, stacktrace) {
    //   return errorGetResponse(error, stacktrace, ApiPath.exportData);
    // }
  }
}
