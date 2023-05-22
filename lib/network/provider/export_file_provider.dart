import 'dart:developer';

import 'package:viet_wallet/network/api/api_path.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';
import 'package:viet_wallet/network/response/base_get_response.dart';

class ExportProvider with ProviderMixin {
  Future<Object> getFileReport({
    required List<int> walletIDs,
    required String fromDate,
    toDate,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }

    /// like: export?fromDate=2023-04-01&toDate=2023-05-01
    final String apiExportFile =
        '${ApiPath.exportData}?fromDate=$fromDate&toDate=$toDate';

    final response = await dio.put(
      apiExportFile,
      data: {'walletIds': walletIDs},
      options: await defaultOptions(url: apiExportFile),
    );
    log('response: ${response.toString()}');

    return response;
    // } catch (error, stacktrace) {
    //   return errorGetResponse(error, stacktrace, ApiPath.exportData);
    // }
  }
}
