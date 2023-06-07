import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
import 'package:viet_wallet/network/api/api_path.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';

import '../../utilities/app_constants.dart';
import '../../utilities/secure_storage.dart';
import '../response/base_response.dart';

class ExportProvider with ProviderMixin {
  Future<Object> getFileReport({
    required Map<String, dynamic> query,
    // required String fromDate,
    // String? toDate,
    // required List<int> walletIDs,
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

      // String url =
      //     '${ApiPath.exportData}?fromDate=$fromDate&toDate=${isNotNullOrEmpty(toDate) ? toDate : ''}';
      // for (var walletId in walletIDs) {
      //   url += '&walletIds=$walletId';
      // }
      // print('url: $url');

      // final http.Response response = await http.get(
      //   Uri.parse(url),
      //   headers: {
      //     'Authorization':
      //         await SecureStorage().readSecureData(AppConstants.accessTokenKey),
      //   },
      // );

      // var httpClient = http.Client();
      // var request = await httpClient.get(
      //   Uri.parse(url),
      //   headers: {
      //     'Authorization':
      //         await SecureStorage().readSecureData(AppConstants.accessTokenKey),
      //   },
      // );
      final file = File(savePath);
      // await file.writeAsBytes(request.bodyBytes);

      await file.writeAsBytes(response.data, flush: true);
      // httpClient.close();

      return file;
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.exportData);
    }
  }
}
