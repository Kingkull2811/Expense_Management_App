import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:viet_wallet/network/api/api_path.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';
import 'package:viet_wallet/network/response/base_get_response.dart';

class ExportProvider with ProviderMixin {
  Future<Object> getFileReport({
    required List<int> walletIDs,
    required String fromDate,
    required String toDate,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final savePath = await getApplicationDocumentsDirectory();

      String tempPath = savePath.path;
      var filePath = '$tempPath/report_${fromDate}_$toDate';

      String url = '${ApiPath.exportData}?fromDate=$fromDate&toDate=$toDate';
      walletIDs.forEach((walletId) {
        url += '&walletIds=$walletId';
      });

      print('url:$url');

      final response = await dio.get(
        // ApiPath.exportData,
        url,
        // queryParameters: {
        //   'fromDate': fromDate,
        //   'toDate': toDate,
        //   'walletIds': walletIDs.map((item) => item.toString()).toList(),
        // },
        // onReceiveProgress: (received, total) {
        //   if (total != -1) {
        //     if (kDebugMode) {
        //       print("${(received / total * 100).toStringAsFixed(0)}%");
        //     }
        //   }
        // },
        options: Options(
          // headers: {
          //   'Authorization': await SecureStorage()
          //       .readSecureData(AppConstants.accessTokenKey),
          // },
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      final file = File(filePath);
      await file.writeAsBytes(response.data, flush: true);

      return file;
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.exportData);
    }
  }
}
