import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:viet_wallet/network/api/api_path.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';

import '../../utilities/app_constants.dart';
import '../../utilities/secure_storage.dart';
import '../response/base_response.dart';

class ExportProvider with ProviderMixin {
  Future<Object> getFileReport({
    required Map<String, dynamic> query,
    required String savePath,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.exportData,
        queryParameters: query,
        options: Options(
          headers: {
            'Authorization': await SecureStorage()
                .readSecureData(AppConstants.accessTokenKey),
          },
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      final file = File(savePath);
      await file.writeAsBytes(response.data, flush: true);
        // var httpClient = http.Client();
        // var request = await httpClient.get(Uri.parse(response.data));
        //
        // var appDocumentsDirectory = await getApplicationDocumentsDirectory();
        // var file = File('${appDocumentsDirectory.path}/$savePath');
        // await file.writeAsBytes(request.bodyBytes);
        //
        // httpClient.close();
        //
        // print('File downloaded to: ${file.path}');
      return file;
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.exportData);
    }
  }
}
