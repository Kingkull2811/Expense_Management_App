import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:viet_wallet/network/provider/auth_provider.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';

import '../../utilities/utils.dart';
import '../response/base_get_response.dart';
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

  BaseGetResponse errorGetResponse(error, stacktrace, apiPath) {
    showErrorLog(error, stacktrace, apiPath);
    return BaseGetResponse.withHttpError(
      status: error.response?.statusCode,
      error: error.toString(),
      pageNumber: null,
      pageSize: null,
      totalRecord: null,
    );
  }

  Future<Options> defaultOptions({
    String? url,
    String? contentType,
    String? accept,
  }) async {
    String? token = SharedPreferencesStorage().getAccessToken();
    // await SecureStorage().readSecureData(AppConstants.accessTokenKey);

    if (isNullOrEmpty(token)) {
      print('****token null*****');
      return Options();
    }
    if (kDebugMode) {
      if (isNotNullOrEmpty(url)) {
        print('URL: $url');
        // log('accessToke: $token');
      }
    }
    return Options(
      headers: {
        'Authorization': token,
        if (contentType != null) 'Content-Type': contentType,
        if (accept != null) 'Accept': accept,
      },
    );
  }

  Future<bool> isExpiredToken() async {
    _authProvider ??= AuthProvider();
    return !(await _authProvider?.checkAuthenticationStatus() ?? false);
  }
}
