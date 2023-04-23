import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:viet_wallet/network/api/api_path.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';

import '../response/base_get_response.dart';
import '../response/get_list_category_response.dart';

class CategoryProvider with ProviderMixin {
  Future<BaseGetResponse> getAllListCategory({
    required String param,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }

    try {
      Options options = await defaultOptions(
        url: ApiPath.getAllListCategory,
      );

      final response = await dio.get(
        ApiPath.getAllListCategory,
        queryParameters: {"type": param},
        options: options,
      );

      return GetCategoryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      log(error.toString());
      return errorGetResponse(error, stacktrace, ApiPath.getAllListCategory);
    }
  }
}
