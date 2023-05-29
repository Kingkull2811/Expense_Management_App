import 'dart:io';

import 'package:dio/dio.dart';
import 'package:viet_wallet/network/api/api_path.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';
import 'package:viet_wallet/network/response/base_get_response.dart';

class ExportProvider with ProviderMixin {
  Future<Object> getFileReport({
    required Map<String, dynamic> query,
    required String savePath,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.exportData,
        queryParameters: query,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      final file = File(savePath);
      await file.writeAsBytes(response.data, flush: true);

      return file;
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.exportData);
    }
  }
}
