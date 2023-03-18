import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:viet_wallet/network/provider/auth_provider.dart';

import '../response/base_response.dart';

mixin ProviderMixin {
  late Dio _dio;
   AuthProvider? _authProvider;

  Dio get dio {
    _dio = Dio()..httpClientAdapter = HttpClientAdapter();
    return _dio;
  }

  void showErrorLog(error, stacktrace, apiPath) {
    if (kDebugMode) {
      if (apiPath != null) {
        print("EXCEPTION OCCURRED: ${apiPath.toString()}");
      }
      if (error is DioError) {
        print("\nEXCEPTION RESPONSE: ${error.response}");
      }
      print("\nEXCEPTION WITH: $error\nSTACKTRACE: $stacktrace");
    } else {
      //record log to firebase crashlytics here}
    }
  }

  BaseResponse errorResponse(error, stacktrace, apiPath) {
    showErrorLog(error, stacktrace, apiPath);

    return BaseResponse.withHttpError(
      message: error,
      httpStatus: (error is DioError) ? error.response?.statusCode : null,
      errors: (error is DioError) ? error.response?.data : [],
    );
  }

  Future<bool> isExpiredToken() async {
    _authProvider ??= AuthProvider();
    return (await _authProvider?.checkAuthenticationStatus() ?? false);
  }
}
