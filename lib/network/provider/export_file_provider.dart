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
    String? toDate,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final savePath = await getApplicationDocumentsDirectory();

      String tempPath = savePath.path;
      var filePath = '$tempPath/report_${fromDate}_$toDate.xlsx';
      var filePathNo = '$tempPath/report_$fromDate.xlsx';

      final response = await dio.get(
        ApiPath.exportData,
        queryParameters: {
          'fromDate': fromDate,
          if (toDate != null) 'toDate': toDate,
          'walletIds': walletIDs.map((item) => item.toString()).toList(),
        },
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

      final file = File(toDate != null ? filePath : filePathNo);
      await file.writeAsBytes(response.data, flush: true);

      return file;
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.exportData);
    }
  }
}
